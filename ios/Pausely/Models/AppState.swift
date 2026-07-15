import Foundation
import SwiftUI

enum AppScreen: Equatable {
    case home
    case startSession
    case activeSession
    case settings
    case overrideConfirm
}

/// Mock app store. Wire Windows companion into these methods later.
@MainActor
final class AppState: ObservableObject {
    @Published var screen: AppScreen = .home
    @Published var settings = UserSettings()
    @Published var activeSession: GamingSession?
    @Published var showingViolation = false
    @Published var statusMessage = "Ready when you are"
    @Published var now: Date = .now
    /// Mock — flip from home until you wire the real Windows agent.
    @Published var companionConnected = true

    private var tickTask: Task<Void, Never>?

    var isWithinAllowedHours: Bool {
        let hour = Calendar.current.component(.hour, from: now)
        if settings.allowedStartHour <= settings.allowedEndHour {
            return hour >= settings.allowedStartHour && hour < settings.allowedEndHour
        }
        // Overnight window (e.g. 22 → 2)
        return hour >= settings.allowedStartHour || hour < settings.allowedEndHour
    }

    func startTicking() {
        tickTask?.cancel()
        tickTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                now = .now
                checkSessionExpiry()
            }
        }
    }

    func stopTicking() {
        tickTask?.cancel()
        tickTask = nil
    }

    func openStartSession() {
        screen = .startSession
    }

    func openSettings() {
        screen = .settings
    }

    func goHome() {
        screen = .home
    }

    func startSession(gameName: String, minutes: Int) {
        // TODO: notify Windows companion that a session started
        let name = gameName.trimmingCharacters(in: .whitespacesAndNewlines)
        activeSession = GamingSession(
            gameName: name.isEmpty ? "Steam Game" : name,
            durationMinutes: minutes,
            startTime: .now,
            status: .active
        )
        statusMessage = "Session running"
        showingViolation = false
        screen = .activeSession
    }

    func endSession() {
        // TODO: ask Windows companion / CV to verify game closed
        activeSession?.status = .ended
        activeSession?.endTime = .now
        activeSession = nil
        statusMessage = "Session ended. Nice."
        showingViolation = false
        screen = .home
    }

    /// Demo / future hook: unauthorized play detected.
    func triggerViolation() {
        // TODO: called when Windows agent detects Steam without an active session
        showingViolation = true
        statusMessage = "Unauthorized play"
        if var session = activeSession {
            session.status = .violated
            activeSession = session
        }
    }

    func confirmClosed() {
        // TODO: replace with CV / agent verification result
        showingViolation = false
        if activeSession != nil {
            endSession()
        } else {
            statusMessage = "Verified closed"
            screen = .home
        }
    }

    func requestOverride() {
        screen = .overrideConfirm
    }

    func confirmOverride() {
        // TODO: log override + optionally tell Windows to stand down briefly
        if var session = activeSession {
            session.status = .overridden
            session.endTime = .now
            activeSession = nil
        }
        showingViolation = false
        statusMessage = "Override used — be intentional"
        screen = .home
    }

    func cancelOverride() {
        screen = activeSession == nil ? .home : .activeSession
    }

    private func checkSessionExpiry() {
        guard let session = activeSession, session.status == .active else { return }
        if session.remaining(now: now) <= 0, settings.nagEnabled {
            showingViolation = true
            statusMessage = "Time's up — wrap it up"
        }
    }
}
