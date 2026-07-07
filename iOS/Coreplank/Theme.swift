import SwiftUI

enum Theme {
    static let background = Color(hex: "#101820")
    static let foreground = Color(hex: "#EAF2F8")
    static let accent = Color(hex: "#3E92CC")
    static let accentSecondary = Color(hex: "#F2B134")

    static var titleFont: Font { .system(.title2, design: .monospaced).weight(.bold) }
    static var bodyFont: Font { .system(.body, design: .monospaced) }
    static var captionFont: Font { .system(.caption, design: .monospaced) }
}

extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        let r = Double((v >> 16) & 0xFF) / 255.0
        let g = Double((v >> 8) & 0xFF) / 255.0
        let b = Double(v & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
