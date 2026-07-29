import SwiftUI

struct HelpBalloon: View {
    let title: String
    let bodyText: String
    var tipNumber: Int? = nil
    var isExpanded: Binding<Bool>? = nil

    @State private var internalExpanded = true

    private var expanded: Binding<Bool> {
        isExpanded ?? Binding(
            get: { internalExpanded },
            set: { internalExpanded = $0 }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    expanded.wrappedValue.toggle()
                }
            } label: {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.seafoam)
                            .frame(width: 28, height: 28)
                        if let tipNumber {
                            Text("\(tipNumber)")
                                .font(.system(.caption, design: .rounded).weight(.bold))
                                .foregroundStyle(.white)
                        } else {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }

                    Text(title)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(AppTheme.ink)
                        .multilineTextAlignment(.leading)

                    Spacer(minLength: 8)

                    Image(systemName: expanded.wrappedValue ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.ink.opacity(0.45))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
            }
            .buttonStyle(.plain)

            if expanded.wrappedValue {
                Text(bodyText)
                    .font(AppTheme.bodyFont)
                    .foregroundStyle(AppTheme.ink.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 14)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppTheme.balloonFill)
                .shadow(color: AppTheme.ink.opacity(0.08), radius: 10, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(AppTheme.balloonStroke.opacity(0.55), lineWidth: 1.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Help: \(title). \(bodyText)")
    }
}

struct FloatingTipAnchor<Content: View>: View {
    let tipTitle: String
    let tipBody: String
    @Binding var showTip: Bool
    let content: Content

    init(
        tipTitle: String,
        tipBody: String,
        showTip: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self.tipTitle = tipTitle
        self.tipBody = tipBody
        self._showTip = showTip
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content
            if showTip {
                HelpBalloon(title: tipTitle, bodyText: tipBody, isExpanded: $showTip)
                    .transition(.scale(scale: 0.96, anchor: .top).combined(with: .opacity))
            }
        }
    }
}

struct StepProgressBar: View {
    let current: ExportStep

    var body: some View {
        HStack(spacing: 6) {
            ForEach(ExportStep.allCases.filter { $0 != .processing }) { step in
                Capsule()
                    .fill(step.rawValue <= current.rawValue ? AppTheme.seafoam : AppTheme.ink.opacity(0.12))
                    .frame(height: 6)
                    .animation(.easeInOut(duration: 0.25), value: current)
            }
        }
        .accessibilityLabel("Step \(current.rawValue + 1) of \(ExportStep.allCases.count)")
    }
}
