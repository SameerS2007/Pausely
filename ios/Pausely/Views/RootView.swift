import SwiftUI

struct RootView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        ZStack {
            PauselyTheme.background

            Group {
                switch state.screen {
                case .home:
                    HomeView()
                case .startSession:
                    StartSessionView()
                case .activeSession:
                    ActiveSessionView()
                case .settings:
                    SettingsView()
                case .overrideConfirm:
                    OverrideConfirmView()
                }
            }
            .transition(.opacity.combined(with: .move(edge: .trailing)))
            .animation(.easeInOut(duration: 0.2), value: state.screen)
        }
        .fullScreenCover(isPresented: $state.showingViolation) {
            ViolationView()
                .environmentObject(state)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
