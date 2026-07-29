import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ScrollPressViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()

                VStack(spacing: 16) {
                    header

                    ScrollView {
                        stepContent
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)
                    }
                }
            }
            .navigationBarHidden(true)
            .alert(L10n.t("ui.alertTitle", viewModel.language), isPresented: errorBinding) {
                Button(L10n.t("ui.ok", viewModel.language), role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .sheet(isPresented: $viewModel.showShareSheet, onDismiss: {
                viewModel.exportURL = nil
            }) {
                if let url = viewModel.exportURL {
                    ShareSheet(items: [url])
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("ScrollPress")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .foregroundStyle(AppTheme.ink)
                    Text(viewModel.step.title(viewModel.language))
                        .font(AppTheme.captionFont)
                        .foregroundStyle(AppTheme.ink.opacity(0.5))
                }

                Spacer(minLength: 4)

                LanguageSwitchButton(viewModel: viewModel)

                Button {
                    viewModel.openHelp(for: viewModel.step)
                } label: {
                    Label(L10n.t("ui.help", viewModel.language), systemImage: "bubble.left.fill")
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(AppTheme.ink)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppTheme.balloonFill)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(AppTheme.balloonStroke.opacity(0.5), lineWidth: 1)
                        )
                }
                .accessibilityHint(viewModel.language == .spanish
                    ? "Muestra el globo de ayuda de este paso"
                    : "Shows the help balloon for this step")
            }

            StepProgressBar(current: viewModel.step)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.step {
        case .welcome:
            WelcomeStepView(viewModel: viewModel)
        case .nameThread:
            NameThreadStepView(viewModel: viewModel)
        case .captureGuide:
            CaptureGuideStepView(viewModel: viewModel)
        case .importMedia:
            ImportMediaStepView(viewModel: viewModel)
        case .processing:
            ProcessingStepView(viewModel: viewModel)
        case .review:
            ReviewStepView(viewModel: viewModel)
        case .export:
            ExportStepView(viewModel: viewModel)
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

#Preview {
    ContentView()
}
