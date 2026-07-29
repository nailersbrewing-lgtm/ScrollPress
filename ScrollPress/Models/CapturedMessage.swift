import Foundation

struct CapturedMessage: Identifiable, Equatable, Hashable {
    let id: UUID
    var text: String
    var timestampText: String?
    var isFromMe: Bool
    var confidence: Double

    init(
        id: UUID = UUID(),
        text: String,
        timestampText: String? = nil,
        isFromMe: Bool,
        confidence: Double = 1.0
    ) {
        self.id = id
        self.text = text
        self.timestampText = timestampText
        self.isFromMe = isFromMe
        self.confidence = confidence
    }

    func directionLabel(language: AppLanguage) -> String {
        isFromMe ? L10n.t("ui.youSent", language) : L10n.t("ui.theySent", language)
    }
}

enum ExportStep: Int, CaseIterable, Identifiable {
    case welcome = 0
    case nameThread = 1
    case captureGuide = 2
    case importMedia = 3
    case processing = 4
    case review = 5
    case export = 6

    var id: Int { rawValue }

    func title(_ language: AppLanguage) -> String {
        switch self {
        case .welcome: return L10n.t("step.welcome", language)
        case .nameThread: return L10n.t("step.nameThread", language)
        case .captureGuide: return L10n.t("step.captureGuide", language)
        case .importMedia: return L10n.t("step.importMedia", language)
        case .processing: return L10n.t("step.processing", language)
        case .review: return L10n.t("step.review", language)
        case .export: return L10n.t("step.export", language)
        }
    }

    func helpTitle(_ language: AppLanguage) -> String {
        switch self {
        case .welcome: return L10n.t("help.welcome.title", language)
        case .nameThread: return L10n.t("help.nameThread.title", language)
        case .captureGuide: return L10n.t("help.captureGuide.title", language)
        case .importMedia: return L10n.t("help.importMedia.title", language)
        case .processing: return L10n.t("help.processing.title", language)
        case .review: return L10n.t("help.review.title", language)
        case .export: return L10n.t("help.export.title", language)
        }
    }

    func helpBody(_ language: AppLanguage) -> String {
        switch self {
        case .welcome: return L10n.t("help.welcome.body", language)
        case .nameThread: return L10n.t("help.nameThread.body", language)
        case .captureGuide: return L10n.t("help.captureGuide.body", language)
        case .importMedia: return L10n.t("help.importMedia.body", language)
        case .processing: return L10n.t("help.processing.body", language)
        case .review: return L10n.t("help.review.body", language)
        case .export: return L10n.t("help.export.body", language)
        }
    }
}
