import SwiftUI

extension Color {
    /// Initialize a Color from a #RRGGBB hex string. Falls back to gray on parse failure.
    init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if s.hasPrefix("#") { s.removeFirst() }
        guard s.count == 6, let value = UInt64(s, radix: 16) else {
            self = .gray
            return
        }
        let r = Double((value >> 16) & 0xFF) / 255.0
        let g = Double((value >> 8) & 0xFF) / 255.0
        let b = Double(value & 0xFF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}

enum Palette {
    /// Curated set of accent tags users can assign to peptides.
    static let peptideTags: [String] = [
        "#4F97F2", // blue
        "#A571F2", // purple
        "#23B26D", // green
        "#F2A23A", // amber
        "#E5605C", // coral
        "#5BCBD6", // teal
        "#F068B0", // pink
        "#7C8794"  // slate
    ]
}

/// A subtle, rounded card surface used across the app.
struct CardBackground: ViewModifier {
    var padding: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
    }
}

extension View {
    func card(padding: CGFloat = 16) -> some View {
        modifier(CardBackground(padding: padding))
    }
}
