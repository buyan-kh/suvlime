import SwiftUI

struct PaywallView: View {
    var onClose: () -> Void

    private let perks = [
        "Unlimited AI coach",
        "Track everything",
        "Smart stack planner",
        "Dose calculator",
        "Lab tracker",
        "Cycle reminders"
    ]

    var body: some View {
        BoldScreen(background: BoldPalette.ink) {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Sticker(text: "3 day free trial", color: BoldPalette.lime)
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .black))
                            .foregroundStyle(.white.opacity(0.55))
                            .frame(width: 34, height: 34)
                            .background(Color.white.opacity(0.08), in: Circle())
                    }
                    .accessibilityLabel("Close paywall")
                }
                Text("Unlock your\nfull stack.")
                    .font(.boldDisplay(50))
                    .lineSpacing(-9)
                    .foregroundStyle(.white)
                    .overlay(alignment: .bottomLeading) {
                        Text("full stack.")
                            .font(.boldDisplay(50))
                            .foregroundStyle(BoldPalette.ink)
                            .padding(.horizontal, 12)
                            .background(BoldPalette.lime)
                            .rotationEffect(.degrees(-1.5))
                    }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                    ForEach(perks, id: \.self) { perk in
                        HStack(spacing: 7) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .black))
                                .foregroundStyle(BoldPalette.ink)
                                .frame(width: 18, height: 18)
                                .background(BoldPalette.lime, in: Circle())
                            Text(perk)
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .lineLimit(2)
                        }
                    }
                }

                VStack(spacing: 12) {
                    PlanRow(title: "Monthly", subtitle: "$14.99/mo", selected: false)
                    PlanRow(title: "Yearly", subtitle: "$79.99/yr - just $1.53/week", selected: true)
                    PlanRow(title: "Weekly", subtitle: "$9.99/wk after trial", selected: false)
                }
                .padding(.top, 4)
                Spacer()
                BoldButton(title: "Start free trial", systemImage: "arrow.right", background: BoldPalette.lime, foreground: BoldPalette.ink, action: onClose)
                HStack {
                    Spacer()
                    Text("Cancel anytime")
                    Text("*")
                    Text("No commitment")
                    Spacer()
                }
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.55))
            }
            .padding(.horizontal, 22)
            .padding(.top, 30)
            .padding(.bottom, 24)
        }
    }
}

private struct PlanRow: View {
    var title: String
    var subtitle: String
    var selected: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.boldBody(selected ? 17 : 14))
                Text(subtitle).font(.system(size: 12, weight: .bold, design: .rounded))
            }
            Spacer()
            Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 24, weight: .black))
        }
        .foregroundStyle(selected ? BoldPalette.ink : .white)
        .padding(16)
        .background(selected ? BoldPalette.lime : Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(selected ? BoldPalette.lime : Color.white.opacity(0.14), lineWidth: selected ? 3 : 2.5)
        )
        .overlay(alignment: .topTrailing) {
            if selected {
                Sticker(text: "Best deal", color: BoldPalette.hot, textColor: .white, rotation: 4, size: .small)
                    .offset(x: -12, y: -17)
            }
        }
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView {}
    }
}
