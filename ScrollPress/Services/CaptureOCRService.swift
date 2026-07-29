import Foundation
import UIKit
import Vision
import AVFoundation
import ImageIO

enum CaptureProcessingError: LocalizedError {
    case noImages
    case failedToReadVideo
    case emptyOCR

    var errorDescription: String? {
        switch self {
        case .noImages:
            return "Please add at least one screenshot or a screen recording."
        case .failedToReadVideo:
            return "Could not read that video. Try exporting it again from Photos."
        case .emptyOCR:
            return "No readable text was found. Scroll slower next time, or use clearer screenshots."
        }
    }
}

struct OCRLine {
    let text: String
    let boundingBox: CGRect
    let confidence: Float
}

final class CaptureOCRService {
    /// Pull evenly spaced frames from a screen recording for OCR.
    func frames(fromVideoURL url: URL, maxFrames: Int = 40) async throws -> [UIImage] {
        let asset = AVURLAsset(url: url)
        let duration = try await asset.load(.duration)
        let totalSeconds = CMTimeGetSeconds(duration)
        guard totalSeconds.isFinite, totalSeconds > 0 else {
            throw CaptureProcessingError.failedToReadVideo
        }

        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 1280, height: 1280)

        let count = min(maxFrames, max(8, Int(totalSeconds * 1.5)))
        var images: [UIImage] = []

        for index in 0..<count {
            let seconds = totalSeconds * Double(index) / Double(max(count - 1, 1))
            let time = CMTime(seconds: seconds, preferredTimescale: 600)
            do {
                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
                images.append(UIImage(cgImage: cgImage))
            } catch {
                continue
            }
        }

        if images.isEmpty {
            throw CaptureProcessingError.failedToReadVideo
        }
        return images
    }

    func recognizeMessages(from images: [UIImage], progress: @escaping (Double) -> Void) async throws -> [CapturedMessage] {
        guard !images.isEmpty else { throw CaptureProcessingError.noImages }

        var collected: [CapturedMessage] = []
        var seenFingerprints = Set<String>()

        for (index, image) in images.enumerated() {
            let lines = try await recognizeLines(in: image)
            let pageMessages = assembleMessages(from: lines, imageSize: image.size)

            for message in pageMessages {
                let fingerprint = fingerprint(for: message)
                if seenFingerprints.insert(fingerprint).inserted {
                    collected.append(message)
                }
            }

            let value = Double(index + 1) / Double(images.count)
            await MainActor.run { progress(value) }
        }

        let cleaned = mergeNearDuplicates(collected)
        guard !cleaned.isEmpty else { throw CaptureProcessingError.emptyOCR }
        return cleaned
    }

    private func recognizeLines(in image: UIImage) async throws -> [OCRLine] {
        guard let cgImage = image.cgImage else { return [] }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let observations = (request.results as? [VNRecognizedTextObservation]) ?? []
                let lines: [OCRLine] = observations.compactMap { observation in
                    guard let top = observation.topCandidates(1).first else { return nil }
                    return OCRLine(
                        text: top.string.trimmingCharacters(in: .whitespacesAndNewlines),
                        boundingBox: observation.boundingBox,
                        confidence: top.confidence
                    )
                }
                .filter { !$0.text.isEmpty }

                continuation.resume(returning: lines)
            }

            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.recognitionLanguages = ["en-US"]

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// Vision boxes use normalized bottom-left origin. MidX helps guess sent vs received.
    private func assembleMessages(from lines: [OCRLine], imageSize: CGSize) -> [CapturedMessage] {
        let sorted = lines.sorted { $0.boundingBox.midY > $1.boundingBox.midY }
        var messages: [CapturedMessage] = []
        var currentText: [String] = []
        var currentIsFromMe = false
        var currentConfidence: Float = 0
        var lastMidY: CGFloat?
        var pendingTimestamp: String?

        func flush() {
            let joined = currentText.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
            guard !joined.isEmpty, !isLikelyUIChrome(joined) else {
                currentText = []
                return
            }
            messages.append(
                CapturedMessage(
                    text: joined,
                    timestampText: pendingTimestamp,
                    isFromMe: currentIsFromMe,
                    confidence: Double(currentConfidence)
                )
            )
            pendingTimestamp = nil
            currentText = []
        }

        for line in sorted {
            if isLikelyTimestamp(line.text) {
                pendingTimestamp = line.text
                continue
            }
            if isLikelyUIChrome(line.text) {
                continue
            }

            let isFromMe = line.boundingBox.midX > 0.52
            let gap = lastMidY.map { $0 - line.boundingBox.midY } ?? 0

            if currentText.isEmpty {
                currentText = [line.text]
                currentIsFromMe = isFromMe
                currentConfidence = line.confidence
                lastMidY = line.boundingBox.midY
            } else if abs(gap) < 0.035, isFromMe == currentIsFromMe {
                currentText.append(line.text)
                currentConfidence = min(currentConfidence, line.confidence)
                lastMidY = line.boundingBox.midY
            } else {
                flush()
                currentText = [line.text]
                currentIsFromMe = isFromMe
                currentConfidence = line.confidence
                lastMidY = line.boundingBox.midY
            }
        }
        flush()

        // Screen recordings usually scroll oldest→newest; frames may reverse order. Keep page order for now.
        _ = imageSize
        return messages
    }

    private func isLikelyTimestamp(_ text: String) -> Bool {
        let patterns = [
            #"^\d{1,2}:\d{2}\s?(AM|PM|am|pm)?$"#,
            #"^(Mon|Tue|Wed|Thu|Fri|Sat|Sun|Yesterday|Today).*"#,
            #"^\w{3}\s\d{1,2},\s\d{1,2}:\d{2}\s?(AM|PM)?$"#,
            #"^Delivered$"#,
            #"^Read$"#,
            #"^Read\s.+$"#
        ]
        return patterns.contains { text.range(of: $0, options: .regularExpression) != nil }
    }

    private func isLikelyUIChrome(_ text: String) -> Bool {
        let blocked: Set<String> = [
            "Messages", "Edit", "Done", "Back", "iMessage", "SMS", "Text Message",
            "Details", "Contact Card", "Send", "Audio", "Photos"
        ]
        if blocked.contains(text) { return true }
        if text.count <= 1 { return true }
        return false
    }

    private func fingerprint(for message: CapturedMessage) -> String {
        let normalized = message.text
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined()
        return "\(message.isFromMe ? "1" : "0")|\(normalized.prefix(80))"
    }

    private func mergeNearDuplicates(_ messages: [CapturedMessage]) -> [CapturedMessage] {
        var result: [CapturedMessage] = []
        for message in messages {
            if let last = result.last {
                let a = last.text.lowercased()
                let b = message.text.lowercased()
                if a == b || a.contains(b) || b.contains(a) {
                    if b.count > a.count {
                        result[result.count - 1] = message
                    }
                    continue
                }
            }
            result.append(message)
        }
        return result
    }
}
