import SwiftUI

/// Intentional friction before override — take a second so it's deliberate.
struct OverrideConfirmView: View {
    @EnvironmentObject private var state: AppState
    @State private var holdProgress: CGFloat = 0
    @State private var holding = false
    @State private var ready = false

    private let holdDuration: Double = 1.6

    var body: some View {
        VStack(spacing: 24) {
            navBar(title: "Override") {
                state.cancelOverride()
            }

            Spacer()

            Text("You sure?")
                .font(.system(size: 40, weight: .black, design: .rounded))
                .foregroundStyle(PauselyTheme.yellow)

            Text("Overrides exist so you can finish with friends — not so you spiral. Hold to confirm.")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)

            ZStack {
                Circle()
                    .stroke(.white.opacity(0.2), lineWidth: 10)
                    .frame(width: 160, height: 160)
                Circle()
                    .trim(from: 0, to: holdProgress)
                    .stroke(PauselyTheme.yellow, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                Text(ready ? "OK" : "HOLD")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 20)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        guard !holding, !ready else { return }
                        holding = true
                        withAnimation(.linear(duration: holdDuration)) {
                            holdProgress = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + holdDuration) {
                            guard holding else { return }
                            ready = true
                            state.confirmOverride()
                        }
                    }
                    .onEnded { _ in
                        holding = false
                        if !ready {
                            withAnimation(.easeOut(duration: 0.2)) {
                                holdProgress = 0
                            }
                        }
                    }
            )

            Spacer()

            Button("Never mind") {
                state.cancelOverride()
            }
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundStyle(.white.opacity(0.7))
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    ZStack {
        PauselyTheme.background
        OverrideConfirmView()
    }
    .environmentObject(AppState())
}
