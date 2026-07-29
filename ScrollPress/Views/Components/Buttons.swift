import SwiftUI

struct PrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .font(.system(.body, design: .rounded).weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isEnabled ? AppTheme.seafoam : AppTheme.ink.opacity(0.2))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .disabled(!isEnabled)
        .buttonStyle(.plain)
    }
}

struct SecondaryButton: View {
    let title: String
    var systemImage: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .font(.system(.body, design: .rounded).weight(.medium))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppTheme.ink.opacity(0.06))
            .foregroundStyle(AppTheme.ink)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct ReviewBubbleRow: View {
    let message: CapturedMessage
    let language: AppLanguage
    let onToggleSide: () -> Void
    let onDelete: () -> Void
    @Binding var text: String

    var body: some View {
        VStack(alignment: message.isFromMe ? .trailing : .leading, spacing: 6) {
            if let stamp = message.timestampText {
                Text(stamp)
                    .font(AppTheme.captionFont)
                    .foregroundStyle(AppTheme.ink.opacity(0.45))
            }

            TextField("Message text", text: $text, axis: .vertical)
                .font(AppTheme.bodyFont)
                .foregroundStyle(message.isFromMe ? .white : AppTheme.ink)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(message.isFromMe ? AppTheme.sentBubble : AppTheme.receivedBubble)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .frame(maxWidth: 300, alignment: message.isFromMe ? .trailing : .leading)

            HStack(spacing: 12) {
                Text(message.directionLabel(language: language))
                    .font(AppTheme.captionFont)
                    .foregroundStyle(AppTheme.ink.opacity(0.55))
                Button(L10n.t("ui.flipSide", language), action: onToggleSide)
                    .font(AppTheme.captionFont.weight(.semibold))
                    .foregroundStyle(AppTheme.seafoam)
                Button(L10n.t("ui.remove", language), role: .destructive, action: onDelete)
                    .font(AppTheme.captionFont.weight(.semibold))
            }
        }
        .frame(maxWidth: .infinity, alignment: message.isFromMe ? .trailing : .leading)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
