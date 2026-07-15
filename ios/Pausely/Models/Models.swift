import Foundation

enum SessionStatus: String, Codable {
    case active
    case ended
    case violated
    case overridden
}

struct GamingSession: Identifiable, Equatable {
    var id: UUID = UUID()
    var gameName: String
    var durationMinutes: Int
    var startTime: Date
    var endTime: Date?
    var status: SessionStatus

    var plannedEnd: Date {
        startTime.addingTimeInterval(TimeInterval(durationMinutes * 60))
    }

    func remaining(now: Date = .now) -> TimeInterval {
        max(0, plannedEnd.timeIntervalSince(now))
    }
}

struct UserSettings: Equatable {
    /// Hour of day 0...23 when gaming is allowed to start.
    var allowedStartHour: Int = 18
    var allowedEndHour: Int = 23
    var defaultSessionMinutes: Int = 60
    var nagEnabled: Bool = true
    var soundEnabled: Bool = true
}
