import SwiftUI

enum BoldPalette {
    static let ink = Color(hex: "#0A0A0A")
    static let paper = Color(hex: "#F5F1E8")
    static let lime = Color(hex: "#CFFF50")
    static let hot = Color(hex: "#FF5A36")
    static let sky = Color(hex: "#7FB8FF")
    static let pink = Color(hex: "#FFB8D9")
    static let butter = Color(hex: "#FFD86B")
    static let paleBlue = Color(hex: "#B8E0FF")
}

extension Color {
    init(hex: String) {
        var raw = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if raw.hasPrefix("#") {
            raw.removeFirst()
        }
        guard raw.count == 6, let value = UInt64(raw, radix: 16) else {
            self = .gray
            return
        }
        self = Color(
            .sRGB,
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255,
            opacity: 1
        )
    }
}

extension Font {
    static func boldDisplay(_ size: CGFloat) -> Font {
        .system(size: size, weight: .black, design: .rounded)
    }

    static func boldBody(_ size: CGFloat) -> Font {
        .system(size: size, weight: .heavy, design: .rounded)
    }
}

