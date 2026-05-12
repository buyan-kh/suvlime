import SwiftUI

struct BoldScreen<Content: View>: View {
    var background: Color = BoldPalette.paper
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            background.ignoresSafeArea()
            content
        }
        .foregroundStyle(BoldPalette.ink)
    }
}

struct Sticker: View {
    var text: String
    var color: Color = BoldPalette.lime
    var textColor: Color = BoldPalette.ink
    var rotation: Double = -4
    var size: Size = .medium

    enum Size {
        case small
        case medium
        case large

        var font: Font {
            switch self {
            case .small: .boldBody(11)
            case .medium: .boldBody(14)
            case .large: .boldBody(18)
            }
        }

        var padding: EdgeInsets {
            switch self {
            case .small: EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            case .medium: EdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14)
            case .large: EdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 18)
            }
        }
    }

    var body: some View {
        Text(text.uppercased())
            .font(size.font)
            .foregroundStyle(textColor)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .padding(size.padding)
            .background(color)
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(BoldPalette.ink, lineWidth: 2.5)
            )
            .offset(x: -3, y: -3)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(BoldPalette.ink)
            )
            .rotationEffect(.degrees(rotation))
    }
}

struct BoldButton: View {
    var title: String
    var systemImage: String? = nil
    var background: Color = BoldPalette.ink
    var foreground: Color = .white
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text(title)
                if let systemImage {
                    Image(systemName: systemImage)
                }
            }
            .font(.boldDisplay(22))
            .frame(maxWidth: .infinity, minHeight: 66)
            .foregroundStyle(foreground)
            .background(background)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(BoldPalette.ink, lineWidth: 3)
            )
            .offset(x: -5, y: -5)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(BoldPalette.ink)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

struct BoldCard<Content: View>: View {
    var background: Color = .white
    var radius: CGFloat = 18
    var shadow: CGFloat = 4
    var padding: CGFloat = 16
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding)
            .background(background)
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(BoldPalette.ink, lineWidth: 3)
            )
            .offset(x: -shadow, y: -shadow)
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(BoldPalette.ink)
            )
    }
}

struct BoldTile: View {
    var title: String
    var subtitle: String? = nil
    var systemImage: String
    var color: Color = .white
    var selected: Bool = false

    var body: some View {
        BoldCard(background: selected ? BoldPalette.lime : color, radius: 18, shadow: selected ? 5 : 3, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 28, weight: .black))
                    .frame(width: 40, height: 40, alignment: .leading)
                Text(title)
                    .font(.boldBody(17))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(BoldPalette.ink.opacity(0.65))
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 108, alignment: .leading)
            .overlay(alignment: .topTrailing) {
                if selected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(BoldPalette.ink, in: Circle())
                        .overlay(Circle().stroke(BoldPalette.paper, lineWidth: 2.5))
                        .offset(x: 21, y: -25)
                }
            }
        }
    }
}

struct PillMascot: View {
    var color: Color = BoldPalette.hot
    var size: CGFloat = 120

    var body: some View {
        ZStack {
            Capsule()
                .fill(color)
                .overlay(Capsule().stroke(BoldPalette.ink, lineWidth: 4))
            HStack(spacing: 0) {
                Capsule()
                    .fill(.white)
                    .overlay(Capsule().stroke(BoldPalette.ink, lineWidth: 4))
                    .frame(width: size * 0.48)
                Spacer(minLength: 0)
            }
            .clipShape(Capsule())
            Rectangle()
                .fill(BoldPalette.ink)
                .frame(width: 4)
            HStack(spacing: size * 0.25) {
                Circle().fill(BoldPalette.ink).frame(width: size * 0.07, height: size * 0.07)
                Circle().fill(BoldPalette.ink).frame(width: size * 0.07, height: size * 0.07)
            }
            VStack {
                Spacer()
                SmileShape()
                    .stroke(BoldPalette.ink, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: size * 0.2, height: size * 0.1)
                    .padding(.bottom, size * 0.18)
            }
            Circle()
                .fill(BoldPalette.lime)
                .overlay(Circle().stroke(BoldPalette.ink, lineWidth: 2.5))
                .frame(width: size * 0.11, height: size * 0.11)
                .offset(x: size * 0.42, y: -size * 0.33)
        }
        .frame(width: size, height: size * 0.62)
        .accessibilityHidden(true)
    }
}

private struct SmileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.maxY)
        )
        return path
    }
}

struct ProgressRing: View {
    var progress: Double
    var lineWidth: CGFloat = 8

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.16), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(BoldPalette.lime, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(Int(progress * 100))%")
                .font(.boldBody(17))
                .foregroundStyle(.white)
        }
    }
}

