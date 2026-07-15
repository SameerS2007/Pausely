import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            navBar(title: "Settings") {
                state.goHome()
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    section("Allowed hours") {
                        stepperRow("Start", value: $state.settings.allowedStartHour, range: 0...23, suffix: ":00")
                        stepperRow("End", value: $state.settings.allowedEndHour, range: 0...23, suffix: ":00")
                    }

                    section("Sessions") {
                        stepperRow(
                            "Default length",
                            value: $state.settings.defaultSessionMinutes,
                            range: 15...180,
                            step: 15,
                            suffix: " min"
                        )
                    }

                    section("Nagging") {
                        toggleRow("Time-up nag", isOn: $state.settings.nagEnabled)
                        toggleRow("Sound (soon)", isOn: $state.settings.soundEnabled)
                    }

                    Text("Windows companion wiring lives in AppState TODOs — connect when ready.")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.45))
                        .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
                .tracking(1.1)
            VStack(spacing: 0) {
                content()
            }
            .padding(.vertical, 4)
            .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    private func stepperRow(
        _ title: String,
        value: Binding<Int>,
        range: ClosedRange<Int>,
        step: Int = 1,
        suffix: String
    ) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.white)
            Spacer()
            Text("\(value.wrappedValue)\(suffix)")
                .foregroundStyle(PauselyTheme.yellow)
                .fontWeight(.bold)
            Stepper("", value: value, in: range, step: step)
                .labelsHidden()
                .tint(PauselyTheme.yellow)
        }
        .font(.system(size: 16, weight: .semibold, design: .rounded))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func toggleRow(_ title: String, isOn: Binding<Bool>) -> some View {
        Toggle(title, isOn: isOn)
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundStyle(.white)
            .tint(PauselyTheme.yellow)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
    }
}

#Preview {
    ZStack {
        PauselyTheme.background
        SettingsView()
    }
    .environmentObject(AppState())
}
