import SwiftUI

/// Explicit EN ↔ ES switch. Does not follow iPhone system language.
struct LanguageSwitchButton: View {
    @ObservedObject var viewModel: ScrollPressViewModel

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.toggleLanguage()
            }
        } label: {
            HStack(spacing: 6) {
                Text(viewModel.language.shortCode)
                    .font(.system(.caption, design: .rounded).weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(AppTheme.seafoam)
                    .clipShape(Capsule())

                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(AppTheme.ink.opacity(0.55))

                Text(viewModel.language.switched.shortCode)
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(AppTheme.ink.opacity(0.7))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.9))
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(AppTheme.ink.opacity(0.12), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(L10n.t("ui.languageButtonHint", viewModel.language))
        .accessibilityValue(viewModel.language.displayName)
        .accessibilityHint(
            viewModel.language == .english
                ? "Switches to Spanish"
                : "Cambia a inglés"
        )
    }
}
