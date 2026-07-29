import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct ImportMediaStepView: View {
    @ObservedObject var viewModel: ScrollPressViewModel
    @State private var photoItems: [PhotosPickerItem] = []
    @State private var showVideoImporter = false

    private var lang: AppLanguage { viewModel.language }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.t("ui.importTitle", lang))
                .font(AppTheme.headlineFont)
                .foregroundStyle(AppTheme.ink)

            if viewModel.showHelpEverywhere, viewModel.balloonOpen[.importMedia] == true {
                HelpBalloon(
                    title: ExportStep.importMedia.helpTitle(lang),
                    bodyText: ExportStep.importMedia.helpBody(lang),
                    tipNumber: 4,
                    isExpanded: Binding(
                        get: { viewModel.balloonOpen[.importMedia] ?? true },
                        set: { viewModel.balloonOpen[.importMedia] = $0 }
                    )
                )
            }

            PhotosPicker(
                selection: $photoItems,
                maxSelectionCount: 60,
                matching: .images
            ) {
                labelCard(
                    icon: "photo.on.rectangle.angled",
                    title: L10n.t("ui.addScreenshots", lang),
                    subtitle: L10n.t("ui.addScreenshotsSub", lang)
                )
            }
            .onChange(of: photoItems) { _, newItems in
                Task { await loadPhotos(newItems) }
            }

            Button {
                showVideoImporter = true
            } label: {
                labelCard(
                    icon: "video.badge.plus",
                    title: L10n.t("ui.addVideo", lang),
                    subtitle: L10n.t("ui.addVideoSub", lang)
                )
            }
            .buttonStyle(.plain)

            if !viewModel.selectedImages.isEmpty {
                HelpBalloon(
                    title: L10n.t("tip.lookingGood.title", lang),
                    bodyText: String(
                        format: L10n.t("tip.lookingGood.body", lang),
                        viewModel.selectedImages.count
                    ),
                    tipNumber: 4
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(viewModel.selectedImages.prefix(12).enumerated()), id: \.offset) { _, image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 96)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                    }
                }

                SecondaryButton(title: L10n.t("ui.clearImports", lang), systemImage: "trash") {
                    viewModel.clearMedia()
                    photoItems = []
                }
            }

            Spacer()

            HStack(spacing: 12) {
                SecondaryButton(title: L10n.t("ui.back", lang), systemImage: "chevron.left", action: viewModel.goBack)
                PrimaryButton(
                    title: L10n.t("ui.readText", lang),
                    systemImage: "text.viewfinder",
                    isEnabled: !viewModel.selectedImages.isEmpty && !viewModel.isBusy,
                    action: viewModel.goNext
                )
            }
        }
        .fileImporter(
            isPresented: $showVideoImporter,
            allowedContentTypes: [.movie, .mpeg4Movie, .quickTimeMovie],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    Task { await viewModel.importVideo(from: url) }
                }
            case .failure(let error):
                viewModel.errorMessage = error.localizedDescription
            }
        }
        .overlay {
            if viewModel.isBusy && viewModel.step == .importMedia {
                ProgressView(L10n.t("ui.loadingVideo", lang))
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private func labelCard(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(AppTheme.seafoam)
                .frame(width: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(AppTheme.ink)
                Text(subtitle)
                    .font(AppTheme.captionFont)
                    .foregroundStyle(AppTheme.ink.opacity(0.55))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(AppTheme.ink.opacity(0.3))
        }
        .padding(14)
        .background(Color.white.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func loadPhotos(_ items: [PhotosPickerItem]) async {
        var images: [UIImage] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                images.append(image)
            }
        }
        viewModel.addImages(images)
    }
}

struct ProcessingStepView: View {
    @ObservedObject var viewModel: ScrollPressViewModel
    private var lang: AppLanguage { viewModel.language }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(L10n.t("ui.processingTitle", lang))
                .font(AppTheme.headlineFont)
                .foregroundStyle(AppTheme.ink)

            HelpBalloon(
                title: ExportStep.processing.helpTitle(lang),
                bodyText: ExportStep.processing.helpBody(lang),
                tipNumber: 5
            )

            ProgressView(value: viewModel.progress)
                .tint(AppTheme.seafoam)
                .padding(.top, 8)

            Text(String(format: L10n.t("ui.processingPct", lang), Int(viewModel.progress * 100)))
                .font(AppTheme.captionFont)
                .foregroundStyle(AppTheme.ink.opacity(0.55))

            Spacer()
        }
    }
}

struct ReviewStepView: View {
    @ObservedObject var viewModel: ScrollPressViewModel
    private var lang: AppLanguage { viewModel.language }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(L10n.t("ui.reviewTitle", lang))
                .font(AppTheme.headlineFont)
                .foregroundStyle(AppTheme.ink)

            if viewModel.showHelpEverywhere, viewModel.balloonOpen[.review] == true {
                HelpBalloon(
                    title: ExportStep.review.helpTitle(lang),
                    bodyText: ExportStep.review.helpBody(lang),
                    tipNumber: 6,
                    isExpanded: Binding(
                        get: { viewModel.balloonOpen[.review] ?? true },
                        set: { viewModel.balloonOpen[.review] = $0 }
                    )
                )
            }

            Text(String(format: L10n.t("ui.messagesFound", lang), viewModel.messages.count, viewModel.threadLabel))
                .font(AppTheme.captionFont)
                .foregroundStyle(AppTheme.ink.opacity(0.55))

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach($viewModel.messages) { $message in
                        ReviewBubbleRow(
                            message: message,
                            language: lang,
                            onToggleSide: { viewModel.toggleDirection(message) },
                            onDelete: { viewModel.deleteMessage(message) },
                            text: $message.text
                        )
                    }
                }
                .padding(.vertical, 4)
            }

            HStack(spacing: 12) {
                SecondaryButton(title: L10n.t("ui.back", lang), systemImage: "chevron.left", action: viewModel.goBack)
                PrimaryButton(
                    title: L10n.t("ui.looksGood", lang),
                    systemImage: "arrow.right",
                    isEnabled: !viewModel.messages.isEmpty,
                    action: viewModel.goNext
                )
            }
        }
    }
}

struct ExportStepView: View {
    @ObservedObject var viewModel: ScrollPressViewModel
    private var lang: AppLanguage { viewModel.language }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(L10n.t("ui.printTitle", lang))
                .font(AppTheme.headlineFont)
                .foregroundStyle(AppTheme.ink)

            if viewModel.showHelpEverywhere, viewModel.balloonOpen[.export] == true {
                HelpBalloon(
                    title: ExportStep.export.helpTitle(lang),
                    bodyText: ExportStep.export.helpBody(lang),
                    tipNumber: 7,
                    isExpanded: Binding(
                        get: { viewModel.balloonOpen[.export] ?? true },
                        set: { viewModel.balloonOpen[.export] = $0 }
                    )
                )
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.threadLabel)
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(AppTheme.ink)
                Text(String(format: L10n.t("ui.messagesReady", lang), viewModel.messages.count))
                    .font(AppTheme.bodyFont)
                    .foregroundStyle(AppTheme.ink.opacity(0.65))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            HelpBalloon(
                title: L10n.t("tip.print.title", lang),
                bodyText: L10n.t("tip.print.body", lang),
                tipNumber: 7
            )

            Spacer()

            PrimaryButton(title: L10n.t("ui.createPDF", lang), systemImage: "doc.richtext") {
                viewModel.exportPDF()
            }

            SecondaryButton(title: L10n.t("ui.startAnother", lang), systemImage: "arrow.counterclockwise") {
                viewModel.restart()
            }

            SecondaryButton(title: L10n.t("ui.backToReview", lang), systemImage: "chevron.left") {
                viewModel.goBack()
            }
        }
    }
}
