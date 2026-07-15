import SwiftUI

/// Full-bleed Alarmy-style nag until the user confirms the game is closed.
struct ViolationView: View {
    @EnvironmentObject private var state: AppState
    @State private var pulse = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    PauselyTheme.danger,
                    Color(red: 0.55, green: 0.05, blue: 0.35),
                    PauselyTheme.purpleDeep
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(PauselyTheme.yellow)
                    .scaleEffect(pulse ? 1.08 : 0.95)
                    .animation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: pulse)

                Text("CLOSE THE GAME")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text("Session time is over — or play wasn't allowed. Save your match, quit, then confirm.")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()

                VStack(spacing: 12) {
                    Button("I Closed It") {
                        state.confirmClosed()
                    }
                    .buttonStyle(PauselyButtonStyle())

                    Button("Need Override") {
                        state.showingViolation = false
                        state.requestOverride()
                    }
                    .buttonStyle(
                        PauselyButtonStyle(
                            fill: Color.white.opacity(0.2),
                            foreground: .white
                        )
                    )
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }
        }
        .onAppear { pulse = true }
    }
}

#Preview {
    ViolationView()
        .environmentObject(AppState())
}
