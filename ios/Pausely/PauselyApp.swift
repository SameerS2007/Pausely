import SwiftUI

@main
struct PauselyApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(state)
                .onAppear { state.startTicking() }
                .onDisappear { state.stopTicking() }
        }
    }
}
