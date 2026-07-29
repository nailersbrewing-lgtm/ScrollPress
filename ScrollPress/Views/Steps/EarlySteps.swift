import SwiftUI

struct WelcomeStepView: View {
    @ObservedObject var viewModel: ScrollPressViewModel

    private var lang: AppLanguage { viewModel.language }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("ScrollPress")
                .font(AppTheme.titleFont)
                .foregroundStyle(AppTheme.ink)

            Text(L10n.t("ui.tagline", lang))
                .font(AppTheme.headlineFont)
                .foregroundStyle(AppTheme.seafoam)

            Text(L10n.t("ui.freeLine", lang))
                .font(AppTheme.bodyFont)
                .foregroundStyle(AppTheme.ink.opacity(0.7))

            Text(lang == .english
                 ? "Tap EN → ES at the top to switch to Spanish."
                 : "Toca ES → EN arriba para cambiar a inglés.")
                .font(AppTheme.captionFont)
                .foregroundStyle(AppTheme.ink.opacity(0.55))

            if viewModel.showHelpEverywhere, viewModel.balloonOpen[.welcome] == true {
                HelpBalloon(
                    title: ExportStep.welcome.helpTitle(lang),
                    bodyText: ExportStep.welcome.helpBody(lang),
                    tipNumber: 1,
                    isExpanded: binding(for: .welcome)
                )
            }

            VStack(alignment: .leading, spacing: 10) {
                featureRow("1", L10n.t("ui.feature1", lang))
                featureRow("2", L10n.t("ui.feature2", lang))
                featureRow("3", L10n.t("ui.feature3", lang))
            }
            .padding(14)
            .background(Color.white.opacity(0.65))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Spacer(minLength: 8)

            PrimaryButton(title: L10n.t("ui.start", lang), systemImage: "arrow.right") {
                viewModel.goNext()
            }
        }
    }

    private func featureRow(_ number: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(number)
                .font(.system(.caption, design: .rounded).weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 22, height: 22)
                .background(AppTheme.ink)
                .clipShape(Circle())
            Text(text)
                .font(AppTheme.bodyFont)
                .foregroundStyle(AppTheme.ink)
        }
    }

    private func binding(for step: ExportStep) -> Binding<Bool> {
        Binding(
            get: { viewModel.balloonOpen[step] ?? true },
            set: { viewModel.balloonOpen[step] = $0 }
        )
    }
}

struct NameThreadStepView: View {
    @ObservedObject var viewModel: ScrollPressViewModel
    private var lang: AppLanguage { viewModel.language }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(L10n.t("ui.labelTitle", lang))
                .font(AppTheme.headlineFont)
                .foregroundStyle(AppTheme.ink)

            if viewModel.showHelpEverywhere, viewModel.balloonOpen[.nameThread] == true {
                HelpBalloon(
                    title: ExportStep.nameThread.helpTitle(lang),
                    bodyText: ExportStep.nameThread.helpBody(lang),
                    tipNumber: 2,
                    isExpanded: binding(for: .nameThread)
                )
            }

            FloatingTipAnchor(
                tipTitle: L10n.t("tip.paste.title", lang),
                tipBody: L10n.t("tip.paste.body", lang),
                showTip: Binding(
                    get: { viewModel.balloonOpen[.nameThread] ?? true },
                    set: { viewModel.balloonOpen[.nameThread] = $0 }
                )
            ) {
                HStack(spacing: 10) {
                    TextField(L10n.t("ui.placeholderLabel", lang), text: $viewModel.threadLabel)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    Button(L10n.t("ui.paste", lang)) {
                        viewModel.pasteLabelFromClipboard()
                    }
                    .buttonStyle(.bordered)
                    .tint(AppTheme.seafoam)
                }
            }

            Spacer()

            HStack(spacing: 12) {
                SecondaryButton(title: L10n.t("ui.back", lang), systemImage: "chevron.left", action: viewModel.goBack)
                PrimaryButton(
                    title: L10n.t("ui.next", lang),
                    systemImage: "arrow.right",
                    isEnabled: viewModel.canContinueFromLabel,
                    action: viewModel.goNext
                )
            }
        }
    }

    private func binding(for step: ExportStep) -> Binding<Bool> {
        Binding(
            get: { viewModel.balloonOpen[step] ?? true },
            set: { viewModel.balloonOpen[step] = $0 }
        )
    }
}

struct CaptureGuideStepView: View {
    @ObservedObject var viewModel: ScrollPressViewModel
    private var lang: AppLanguage { viewModel.language }

    private var tips: [(String, String)] {
        [
            (L10n.t("guide.record.title", lang), L10n.t("guide.record.body", lang)),
            (L10n.t("guide.open.title", lang), L10n.t("guide.open.body", lang)),
            (L10n.t("guide.scroll.title", lang), L10n.t("guide.scroll.body", lang)),
            (L10n.t("guide.stop.title", lang), L10n.t("guide.stop.body", lang))
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.t("ui.captureTitle", lang))
                .font(AppTheme.headlineFont)
                .foregroundStyle(AppTheme.ink)

            if viewModel.showHelpEverywhere, viewModel.balloonOpen[.captureGuide] == true {
                HelpBalloon(
                    title: ExportStep.captureGuide.helpTitle(lang),
                    bodyText: ExportStep.captureGuide.helpBody(lang),
                    tipNumber: 3,
                    isExpanded: binding(for: .captureGuide)
                )
            }

            ForEach(Array(tips.enumerated()), id: \.offset) { index, tip in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.system(.subheadline, design: .rounded).weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(AppTheme.seafoam)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 4) {
                        Text(tip.0)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(AppTheme.ink)
                        Text(tip.1)
                            .font(AppTheme.bodyFont)
                            .foregroundStyle(AppTheme.ink.opacity(0.7))
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

            HelpBalloon(
                title: L10n.t("tip.screenshots.title", lang),
                bodyText: L10n.t("tip.screenshots.body", lang),
                tipNumber: 3
            )

            Spacer()

            HStack(spacing: 12) {
                SecondaryButton(title: L10n.t("ui.back", lang), systemImage: "chevron.left", action: viewModel.goBack)
                PrimaryButton(title: L10n.t("ui.captured", lang), systemImage: "checkmark", action: viewModel.goNext)
            }
        }
    }

    private func binding(for step: ExportStep) -> Binding<Bool> {
        Binding(
            get: { viewModel.balloonOpen[step] ?? true },
            set: { viewModel.balloonOpen[step] = $0 }
        )
    }
}
