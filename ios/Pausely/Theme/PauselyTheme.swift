import SwiftUI

enum PauselyTheme {
    static let purpleDeep = Color(red: 0.16, green: 0.04, blue: 0.32)
    static let purpleMid = Color(red: 0.35, green: 0.12, blue: 0.62)
    static let purpleBright = Color(red: 0.48, green: 0.22, blue: 0.82)

    static let yellow = Color(red: 1.0, green: 0.84, blue: 0.12)
    static let yellowDeep = Color(red: 0.78, green: 0.58, blue: 0.02)
    static let yellowHighlight = Color(red: 1.0, green: 0.94, blue: 0.45)

    static let danger = Color(red: 1.0, green: 0.28, blue: 0.32)
    static let ink = Color.white

    static var background: some View {
        LinearGradient(
            colors: [purpleBright, purpleMid, purpleDeep],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct PauselyButtonStyle: ButtonStyle {
    var fill: Color = PauselyTheme.yellow
    var foreground: Color = PauselyTheme.purpleDeep

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .heavy, design: .rounded))
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(fill)
                    .shadow(color: .black.opacity(0.35), radius: 0, x: 0, y: configuration.isPressed ? 1 : 5)
            )
            .offset(y: configuration.isPressed ? 4 : 0)
    }
}
