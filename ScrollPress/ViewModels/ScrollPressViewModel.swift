import Foundation
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

@MainActor
final class ScrollPressViewModel: ObservableObject {
    @Published var step: ExportStep = .welcome
    @Published var threadLabel = ""
    @Published var messages: [CapturedMessage] = []
    @Published var selectedImages: [UIImage] = []
    @Published var isBusy = false
    @Published var progress: Double = 0
    @Published var errorMessage: String?
    @Published var exportURL: URL?
    @Published var showShareSheet = false
    @Published var showHelpEverywhere = true
    @Published var language: AppLanguage {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: "scrollpress.language") }
    }

    /// Per-step balloon visibility (user can dismiss, Help button restores).
    @Published var balloonOpen: [ExportStep: Bool] = Dictionary(
        uniqueKeysWithValues: ExportStep.allCases.map { ($0, true) }
    )

    private let ocr = CaptureOCRService()

    init() {
        // Only the language button changes this — no automatic system-language choice.
        if let saved = UserDefaults.standard.string(forKey: "scrollpress.language"),
           let language = AppLanguage(rawValue: saved) {
            self.language = language
        } else {
            self.language = .english
        }
    }

    var canContinueFromLabel: Bool {
        !threadLabel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func toggleLanguage() {
        language.toggle()
        // Re-open help so balloons refresh in the new language.
        openHelp(for: step)
    }

    func pasteLabelFromClipboard() {
        if let value = UIPasteboard.general.string?.trimmingCharacters(in: .whitespacesAndNewlines),
           !value.isEmpty {
            threadLabel = value
        }
    }

    func openHelp(for step: ExportStep) {
        showHelpEverywhere = true
        balloonOpen[step] = true
    }

    func goNext() {
        switch step {
        case .welcome:
            step = .nameThread
        case .nameThread:
            guard canContinueFromLabel else {
                errorMessage = L10n.t("error.needLabel", language)
                return
            }
            step = .captureGuide
        case .captureGuide:
            step = .importMedia
        case .importMedia:
            Task { await processCapture() }
        case .processing:
            break
        case .review:
            guard !messages.isEmpty else {
                errorMessage = L10n.t("error.nothingToExport", language)
                return
            }
            step = .export
        case .export:
            break
        }
    }

    func goBack() {
        switch step {
        case .welcome:
            break
        case .nameThread:
            step = .welcome
        case .captureGuide:
            step = .nameThread
        case .importMedia:
            step = .captureGuide
        case .processing:
            step = .importMedia
        case .review:
            step = .importMedia
        case .export:
            step = .review
        }
    }

    func addImages(_ images: [UIImage]) {
        selectedImages.append(contentsOf: images)
    }

    func clearMedia() {
        selectedImages = []
        messages = []
        exportURL = nil
    }

    func processCapture() async {
        guard !selectedImages.isEmpty else {
            errorMessage = CaptureProcessingError.noImages.localizedDescription
            return
        }

        step = .processing
        isBusy = true
        progress = 0
        errorMessage = nil

        do {
            let result = try await ocr.recognizeMessages(from: selectedImages) { [weak self] value in
                Task { @MainActor in
                    self?.progress = value
                }
            }
            messages = result
            step = .review
        } catch {
            errorMessage = error.localizedDescription
            step = .importMedia
        }

        isBusy = false
    }

    func importVideo(from url: URL) async {
        isBusy = true
        errorMessage = nil
        do {
            let didAccess = url.startAccessingSecurityScopedResource()
            defer { if didAccess { url.stopAccessingSecurityScopedResource() } }
            let frames = try await ocr.frames(fromVideoURL: url)
            selectedImages.append(contentsOf: frames)
        } catch {
            errorMessage = error.localizedDescription
        }
        isBusy = false
    }

    func updateMessage(_ message: CapturedMessage) {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else { return }
        messages[index] = message
    }

    func deleteMessage(_ message: CapturedMessage) {
        messages.removeAll { $0.id == message.id }
    }

    func toggleDirection(_ message: CapturedMessage) {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else { return }
        messages[index].isFromMe.toggle()
    }

    func exportPDF() {
        do {
            let url = try PrintPDFExporter.makePDF(messages: messages, threadLabel: threadLabel)
            exportURL = url
            showShareSheet = true
        } catch {
            errorMessage = "Could not create PDF: \(error.localizedDescription)"
        }
    }

    func restart() {
        step = .welcome
        threadLabel = ""
        messages = []
        selectedImages = []
        progress = 0
        exportURL = nil
        balloonOpen = Dictionary(uniqueKeysWithValues: ExportStep.allCases.map { ($0, true) })
    }
}
