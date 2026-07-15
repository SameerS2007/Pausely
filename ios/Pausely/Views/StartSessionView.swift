import SwiftUI

struct StartSessionView: View {
    @EnvironmentObject private var state: AppState
    @State private var gameName = ""
    @State private var minutes: Int = 60

    private let presets = [30, 45, 60, 90, 120]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            navBar(title: "New Session") {
                state.goHome()
            }

            VStack(alignment: .leading, spacing: 10) {
                label("Game")
                TextField("e.g. Elden Ring", text: $gameName)
                    .textInputAutocapitalization(.words)
                    .padding()
                    .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 24)

            VStack(alignment: .leading, spacing: 12) {
                label("How long?")
                Text("\(minutes) min")
                    .font(.system(size: 56, weight: .black, design: .rounded))
                    .foregroundStyle(PauselyTheme.yellow)
                    .frame(maxWidth: .infinity)

                HStack(spacing: 10) {
                    ForEach(presets, id: \.self) { preset in
                        Button("\(preset)") {
                            minutes = preset
                        }
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(minutes == preset ? PauselyTheme.purpleDeep : .white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            Capsule().fill(minutes == preset ? PauselyTheme.yellow : Color.white.opacity(0.15))
                        )
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)

            Spacer()

            Button("Start Playing") {
                state.startSession(gameName: gameName, minutes: minutes)
            }
            .buttonStyle(PauselyButtonStyle())
            .padding(.horizontal, 24)
            .padding(.bottom, 36)
        }
        .onAppear {
            minutes = state.settings.defaultSessionMinutes
        }
    }

    private func label(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.system(size: 12, weight: .heavy, design: .rounded))
            .foregroundStyle(.white.opacity(0.55))
            .tracking(1.2)
    }
}

func navBar(title: String, back: @escaping () -> Void) -> some View {
    HStack {
        Button(action: back) {
            Image(systemName: "chevron.left")
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
                .padding(10)
        }
        Spacer()
        Text(title)
            .font(.system(size: 18, weight: .heavy, design: .rounded))
            .foregroundStyle(.white)
        Spacer()
        Color.clear.frame(width: 44, height: 44)
    }
    .padding(.horizontal, 8)
    .padding(.top, 8)
}

#Preview {
    ZStack {
        PauselyTheme.background
        StartSessionView()
    }
    .environmentObject(AppState())
}
