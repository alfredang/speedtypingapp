import SwiftUI

/// Brand tokens for SpeedTyping. Reference these everywhere — never raw Color literals.
enum Theme {
    static let primary   = Color(hex: 0x4F8CFF)   // primary accent / key buttons
    static let secondary = Color(hex: 0x34D399)   // success, links, selected tabs
    static let accent    = primary
    static let highlight = Color(hex: 0xFBBF24)   // badges, current key, ratings
    static let danger    = Color(hex: 0xF87171)   // errors / fail

    static let background = Color(hex: 0x0E1117)   // app background
    static let surface    = Color(hex: 0x1A1F2B)   // subtle fills / chips
    static let card       = Color(hex: 0x161B25)   // elevated card surface

    static let ink      = Color(hex: 0xF5F7FA)     // primary text
    static let mutedInk = Color(hex: 0x9AA4B2)     // secondary text

    /// Eight finger colors used by the fingering guide & on-screen keyboard.
    static let fingerColors: [Color] = [
        Color(hex: 0xEF4444), // L pinky
        Color(hex: 0xF59E0B), // L ring
        Color(hex: 0x10B981), // L middle
        Color(hex: 0x3B82F6), // L index
        Color(hex: 0x8B5CF6), // R index
        Color(hex: 0xEC4899), // R middle
        Color(hex: 0x14B8A6), // R ring
        Color(hex: 0xF97316), // R pinky
    ]
}

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

// MARK: - Reusable card surface

struct AppCard: ViewModifier {
    var padding: CGFloat = 16
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
    }
}

extension View {
    func appCard(padding: CGFloat = 16) -> some View {
        modifier(AppCard(padding: padding))
    }
}
