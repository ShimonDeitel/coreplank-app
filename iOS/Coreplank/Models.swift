import Foundation

struct PlankEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var holdSeconds: Double
    var variation: String
    var notes: String

    init(id: UUID = UUID(), date: Date = Date(), holdSeconds: Double = 0, variation: String = "", notes: String = "") {
        self.id = id
        self.date = date
        self.holdSeconds = holdSeconds
        self.variation = variation
        self.notes = notes
    }
}

struct AppSettings: Codable, Equatable {
    var remindersEnabled: Bool = true
    var metricUnits: Bool = false
    var includeInStreak: Bool = true
}
