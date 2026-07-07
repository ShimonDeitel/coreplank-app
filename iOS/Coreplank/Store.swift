import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeTierLimit = 25

    @Published var entries: [PlankEntry] = []
    @Published var settings: AppSettings = AppSettings()
    @Published var isPro: Bool = false

    private let entriesURL: URL
    private let settingsURL: URL

    init() {
        let dir = Store.appSupportDirectory()
        entriesURL = dir.appendingPathComponent("entries.json")
        settingsURL = dir.appendingPathComponent("settings.json")
        load()
        if entries.isEmpty {
            entries = Store.seedData()
            save()
        }
    }

    static func appSupportDirectory() -> URL {
        let fm = FileManager.default
        let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let dir = base.appendingPathComponent("Coreplank", isDirectory: true)
        if !fm.fileExists(atPath: dir.path) {
            try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    static func seedData() -> [PlankEntry] {
        [
        PlankEntry(date: Calendar.current.date(byAdding: .day, value: -0, to: Date()) ?? Date(), holdSeconds: 10.0, variation: "Sample 1", notes: ""),
        PlankEntry(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), holdSeconds: 13.0, variation: "Sample 2", notes: ""),
        PlankEntry(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), holdSeconds: 16.0, variation: "Sample 3", notes: ""),
        PlankEntry(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), holdSeconds: 19.0, variation: "Sample 4", notes: ""),
        PlankEntry(date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), holdSeconds: 22.0, variation: "Sample 5", notes: ""),
        PlankEntry(date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), holdSeconds: 25.0, variation: "Sample 6", notes: "")
        ]
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeTierLimit
    }

    @discardableResult
    func add(_ entry: PlankEntry) -> Bool {
        guard canAddMore else { return false }
        entries.insert(entry, at: 0)
        save()
        return true
    }

    func update(_ entry: PlankEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: PlankEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func load() {
        let fm = FileManager.default
        if fm.fileExists(atPath: entriesURL.path),
           let data = try? Data(contentsOf: entriesURL),
           let decoded = try? JSONDecoder().decode([PlankEntry].self, from: data) {
            entries = decoded
        }
        if fm.fileExists(atPath: settingsURL.path),
           let data = try? Data(contentsOf: settingsURL),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decoded
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: entriesURL, options: .atomic)
        }
        if let data = try? JSONEncoder().encode(settings) {
            try? data.write(to: settingsURL, options: .atomic)
        }
    }
}
