import SwiftUI

enum AppTheme {
    static let ink = Color(red: 0.10, green: 0.18, blue: 0.28)
    static let seafoam = Color(red: 0.20, green: 0.62, blue: 0.58)
    static let softMint = Color(red: 0.88, green: 0.95, blue: 0.93)
    static let paper = Color(red: 0.97, green: 0.98, blue: 0.96)
    static let sentBubble = Color(red: 0.20, green: 0.62, blue: 0.58)
    static let receivedBubble = Color(red: 0.90, green: 0.92, blue: 0.94)
    static let balloonFill = Color(red: 1.0, green: 0.97, blue: 0.86)
    static let balloonStroke = Color(red: 0.85, green: 0.70, blue: 0.25)
    static let danger = Color(red: 0.75, green: 0.28, blue: 0.28)

    static let titleFont = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.title2, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}

struct PaperBackground: View {
    var body: some View {
        ZStack {
            AppTheme.paper
            LinearGradient(
                colors: [
                    AppTheme.softMint.opacity(0.55),
                    AppTheme.paper.opacity(0.2),
                    AppTheme.paper
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            GeometryReader { geo in
                Path { path in
                    let step: CGFloat = 28
                    var y: CGFloat = 0
                    while y < geo.size.height {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geo.size.width, y: y))
                        y += step
                    }
                }
                .stroke(AppTheme.ink.opacity(0.035), lineWidth: 1)
            }
        }
        .ignoresSafeArea()
    }
}
