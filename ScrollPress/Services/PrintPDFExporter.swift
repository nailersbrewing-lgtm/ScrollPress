import UIKit

enum PrintPDFExporter {
    static func makePDF(
        messages: [CapturedMessage],
        threadLabel: String,
        exportedAt: Date = Date()
    ) throws -> URL {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 42
        let contentWidth = pageWidth - margin * 2

        let titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let metaFont = UIFont.systemFont(ofSize: 11, weight: .regular)
        let bodyFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        let tinyFont = UIFont.systemFont(ofSize: 9, weight: .medium)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        )

        let data = renderer.pdfData { context in
            var y = margin

            func ensureSpace(_ needed: CGFloat) {
                if y + needed > pageHeight - margin {
                    context.beginPage()
                    y = margin
                    drawFooter(on: context)
                }
            }

            func drawFooter(on context: UIGraphicsPDFRendererContext) {
                let footer = "ScrollPress • Free personal printout • \(dateFormatter.string(from: exportedAt))"
                footer.draw(
                    at: CGPoint(x: margin, y: pageHeight - 28),
                    withAttributes: [
                        .font: tinyFont,
                        .foregroundColor: UIColor.gray
                    ]
                )
            }

            context.beginPage()
            drawFooter(on: context)

            let title = "ScrollPress Thread"
            title.draw(
                in: CGRect(x: margin, y: y, width: contentWidth, height: 28),
                withAttributes: [.font: titleFont, .foregroundColor: UIColor(red: 0.10, green: 0.18, blue: 0.28, alpha: 1)]
            )
            y += 34

            let meta = "Label: \(threadLabel.isEmpty ? "Untitled thread" : threadLabel)\nMessages: \(messages.count)\nCreated: \(dateFormatter.string(from: exportedAt))\nNote: Built from your on-screen capture. Read/Delivered only appears if it was visible."
            let metaHeight = meta.height(width: contentWidth, font: metaFont)
            meta.draw(
                in: CGRect(x: margin, y: y, width: contentWidth, height: metaHeight),
                withAttributes: [.font: metaFont, .foregroundColor: UIColor.darkGray]
            )
            y += metaHeight + 18

            for message in messages {
                let bubbleWidth = contentWidth * 0.72
                let textHeight = message.text.height(width: bubbleWidth - 24, font: bodyFont)
                let bubbleHeight = max(36, textHeight + 20)
                let stamp = [message.timestampText, message.directionLabel]
                    .compactMap { $0 }
                    .joined(separator: " • ")
                let stampHeight = stamp.isEmpty ? 0 : stamp.height(width: contentWidth, font: tinyFont)
                ensureSpace(bubbleHeight + stampHeight + 20)

                if !stamp.isEmpty {
                    stamp.draw(
                        in: CGRect(x: margin, y: y, width: contentWidth, height: stampHeight),
                        withAttributes: [.font: tinyFont, .foregroundColor: UIColor.gray]
                    )
                    y += stampHeight + 4
                }

                let bubbleX = message.isFromMe ? margin + (contentWidth - bubbleWidth) : margin
                let rect = CGRect(x: bubbleX, y: y, width: bubbleWidth, height: bubbleHeight)
                let fill = message.isFromMe
                    ? UIColor(red: 0.20, green: 0.62, blue: 0.58, alpha: 1)
                    : UIColor(white: 0.90, alpha: 1)
                let textColor: UIColor = message.isFromMe ? .white : UIColor(red: 0.10, green: 0.18, blue: 0.28, alpha: 1)

                UIBezierPath(roundedRect: rect, cornerRadius: 14).fill(with: fill)

                message.text.draw(
                    in: rect.insetBy(dx: 12, dy: 10),
                    withAttributes: [.font: bodyFont, .foregroundColor: textColor]
                )
                y += bubbleHeight + 12
            }
        }

        let safeName = threadLabel
            .replacingOccurrences(of: "/", with: "-")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let fileName = "ScrollPress-\(safeName.isEmpty ? "Thread" : safeName).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try data.write(to: url, options: .atomic)
        return url
    }
}

private extension String {
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let rect = (self as NSString).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return ceil(rect.height)
    }
}

private extension UIBezierPath {
    func fill(with color: UIColor) {
        color.setFill()
        fill()
    }
}
