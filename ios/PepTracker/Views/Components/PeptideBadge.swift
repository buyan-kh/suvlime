import SwiftUI

/// Circular icon tile used to identify a peptide throughout the app.
struct PeptideBadge: View {
    let symbolName: String
    let colorHex: String
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: colorHex).opacity(0.18))
            Image(systemName: symbolName)
                .font(.system(size: size * 0.45, weight: .semibold))
                .foregroundStyle(Color(hex: colorHex))
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

#Preview {
    HStack(spacing: 12) {
        PeptideBadge(symbolName: "leaf.fill", colorHex: "#4F97F2")
        PeptideBadge(symbolName: "bolt.heart.fill", colorHex: "#A571F2", size: 56)
        PeptideBadge(symbolName: "syringe.fill", colorHex: "#23B26D", size: 32)
    }
    .padding()
}
