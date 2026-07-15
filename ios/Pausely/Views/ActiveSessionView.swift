import SwiftUI

struct ActiveSessionView: View {
    @EnvironmentObject private var state: AppState

    private var remaining: TimeInterval {
        state.activeSession?.remaining(now: state.now) ?? 0
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("PLAYING")
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .tracking(2)
                .foregroundStyle(.white.opacity(0.5))
                .padding(.top, 20)

            Text(state.activeSession?.gameName ?? "Game")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))

            Spacer()

            // Alarmy-style giant clock
            Text(timeString(remaining))
                .font(.system(size: 72, weight: .black, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(remaining <= 60 ? PauselyTheme.danger : PauselyTheme.yellow)
                .shadow(color: .black.opacity(0.35), radius: 12, y: 6)
                .contentTransition(.numericText())
                .animation(.linear(duration: 0.2), value: Int(remaining))

            Text(remaining <= 0 ? "TIME'S UP" : "REMAINING")
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .tracking(3)
                .foregroundStyle(.white.opacity(0.55))

            Spacer()

            VStack(spacing: 12) {
                Button("I'm Done — Verify Close") {
                    state.triggerViolation()
                }
                .buttonStyle(PauselyButtonStyle())

                Button("Override") {
                    state.requestOverride()
                }
                .buttonStyle(
                    PauselyButtonStyle(
                        fill: Color.white.opacity(0.16),
                        foreground: .white
                    )
                )
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 36)
        }
    }

    private func timeString(_ t: TimeInterval) -> String {
        let total = max(0, Int(t))
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        }
        return String(format: "%02d:%02d", m, s)
    }
}

#Preview {
    ZStack {
        PauselyTheme.background
        ActiveSessionView()
    }
    .environmentObject(AppState())
}
