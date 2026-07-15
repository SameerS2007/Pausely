import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var state: AppState
    @State private var gameName = ""
    @State private var minutes: Int = 60

    private let durationPresets = [30, 45, 60, 90, 120]

    var body: some View {
        VStack(spacing: 0) {
            topBar

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    header

                    companionRow
                    todayStrip

                    blockSection
                    sessionSection
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 28)
            }

            Button("Start Playing") {
                state.startSession(gameName: gameName, minutes: minutes)
            }
            .buttonStyle(PauselyButtonStyle())
            .padding(.horizontal, 22)
            .padding(.bottom, 28)
            .padding(.top, 8)
        }
        .onAppear {
            minutes = state.settings.defaultSessionMinutes
        }
    }

    // MARK: - Top

    private var topBar: some View {
        HStack {
            Spacer()
            Button {
                state.openSettings()
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(10)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 4)
    }

    private var header: some View {
        VStack(spacing: 10) {
            PauselyLogo(size: 40)
            Text("Don't play too much.")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
        .padding(.bottom, 4)
    }

    // MARK: - Status fill

    private var companionRow: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(state.companionConnected ? Color.green : PauselyTheme.danger)
                .frame(width: 10, height: 10)
                .shadow(
                    color: (state.companionConnected ? Color.green : PauselyTheme.danger).opacity(0.6),
                    radius: 6
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(state.companionConnected ? "Windows companion" : "Companion offline")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text(state.companionConnected ? "Watching Steam on this PC" : "Connect later — UI only for now")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.55))
            }

            Spacer()

            Button(state.companionConnected ? "On" : "Off") {
                state.companionConnected.toggle()
            }
            .font(.system(size: 13, weight: .heavy, design: .rounded))
            .foregroundStyle(state.companionConnected ? PauselyTheme.purpleDeep : .white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule().fill(state.companionConnected ? PauselyTheme.yellow : Color.white.opacity(0.15))
            )
        }
        .padding(16)
        .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var todayStrip: some View {
        HStack(spacing: 12) {
            Image(systemName: state.isWithinAllowedHours ? "gamecontroller.fill" : "lock.fill")
                .font(.title3)
                .foregroundStyle(PauselyTheme.yellow)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(state.isWithinAllowedHours ? "Play window open" : "Blocked right now")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text(blockWindowLabel)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.55))
            }

            Spacer()
        }
        .padding(16)
        .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var blockWindowLabel: String {
        let start = hourLabel(state.settings.allowedStartHour)
        let end = hourLabel(state.settings.allowedEndHour)
        return "Gaming allowed \(start) – \(end)"
    }

    // MARK: - Block hours

    private var blockSection: some View {
        homeSection("Blocked outside") {
            Text("Games outside this window trigger the Alarmy nag.")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
                .padding(.horizontal, 16)
                .padding(.top, 12)

            HStack(spacing: 16) {
                hourPicker("From", hour: $state.settings.allowedStartHour)
                Image(systemName: "arrow.right")
                    .foregroundStyle(.white.opacity(0.4))
                    .padding(.top, 18)
                hourPicker("Until", hour: $state.settings.allowedEndHour)
            }
            .padding(16)
        }
    }

    private func hourPicker(_ title: String, hour: Binding<Int>) -> some View {
        VStack(spacing: 8) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .foregroundStyle(.white.opacity(0.45))
                .tracking(1)

            Text(hourLabel(hour.wrappedValue))
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundStyle(PauselyTheme.yellow)
                .monospacedDigit()

            HStack(spacing: 10) {
                Button {
                    hour.wrappedValue = (hour.wrappedValue + 23) % 24
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Color.white.opacity(0.15)))
                }

                Button {
                    hour.wrappedValue = (hour.wrappedValue + 1) % 24
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Color.white.opacity(0.15)))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Session

    private var sessionSection: some View {
        homeSection("Start a session") {
            VStack(alignment: .leading, spacing: 14) {
                TextField("Game name", text: $gameName)
                    .textInputAutocapitalization(.words)
                    .padding()
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .foregroundStyle(.white)

                Text("\(minutes) min")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundStyle(PauselyTheme.yellow)
                    .frame(maxWidth: .infinity)

                HStack(spacing: 8) {
                    ForEach(durationPresets, id: \.self) { preset in
                        Button("\(preset)") {
                            minutes = preset
                            state.settings.defaultSessionMinutes = preset
                        }
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(minutes == preset ? PauselyTheme.purpleDeep : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Capsule().fill(minutes == preset ? PauselyTheme.yellow : Color.white.opacity(0.12))
                        )
                    }
                }
            }
            .padding(16)
        }
    }

    // MARK: - Helpers

    private func homeSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
                .tracking(1.2)
                .padding(.bottom, 10)

            VStack(alignment: .leading, spacing: 0) {
                content()
            }
            .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    private func hourLabel(_ hour: Int) -> String {
        let h = hour % 12 == 0 ? 12 : hour % 12
        let suffix = hour < 12 ? "AM" : "PM"
        return "\(h) \(suffix)"
    }
}

#Preview {
    ZStack {
        PauselyTheme.background
        HomeView()
    }
    .environmentObject(AppState())
}
