import SwiftUI

struct ProgressView: View {
    @Bindable var viewModel: ProgressViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        BoldScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 8) {
                            Sticker(text: "9 weeks in", color: BoldPalette.lime, size: .small)
                            Text("You're\nwinning.")
                                .font(.boldDisplay(38))
                                .lineSpacing(-6)
                        }
                        Spacer()
                        Sticker(text: "Top 8%", color: BoldPalette.hot, textColor: .white, rotation: 4)
                    }

                    BoldCard(background: BoldPalette.ink, radius: 22, shadow: 5) {
                        Text("SUPPSAI SCORE")
                            .font(.boldBody(11))
                            .foregroundStyle(BoldPalette.lime)
                        HStack(alignment: .lastTextBaseline, spacing: 8) {
                            Text("\(viewModel.score)")
                                .font(.boldDisplay(72))
                                .foregroundStyle(BoldPalette.lime)
                            Text("up 27 since week 1")
                                .font(.boldBody(14))
                                .foregroundStyle(.white)
                        }
                        ScoreChart(history: viewModel.history)
                            .frame(height: 78)
                    }

                    BoldCard(background: BoldPalette.lime) {
                        Sticker(text: "Weekly recap", color: BoldPalette.hot, textColor: .white, rotation: -5, size: .small)
                        Text(viewModel.recap)
                            .font(.boldBody(17))
                            .lineSpacing(3)
                            .padding(.top, 4)
                    }

                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.metrics) { metric in
                            MetricCard(metric: metric)
                        }
                    }

                    BoldCard(background: BoldPalette.sky) {
                        HStack(spacing: 12) {
                            Image(systemName: "note.text")
                                .font(.boldDisplay(34))
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Weekly check-in")
                                    .font(.boldBody(15))
                                Text("5 questions - 1 minute")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                            }
                            Spacer()
                            Text("Start")
                                .font(.boldBody(14))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(BoldPalette.ink)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                }
                .padding(20)
                .padding(.bottom, 20)
            }
        }
    }
}

private struct ScoreChart: View {
    var history: [Int]

    var body: some View {
        GeometryReader { proxy in
            let minValue = Double(history.min() ?? 0)
            let maxValue = Double(history.max() ?? 100)
            let range = max(maxValue - minValue, 1)
            Path { path in
                for index in history.indices {
                    let x = proxy.size.width * CGFloat(index) / CGFloat(max(history.count - 1, 1))
                    let normalized = (Double(history[index]) - minValue) / range
                    let y = proxy.size.height * CGFloat(1 - normalized)
                    if index == history.startIndex {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(BoldPalette.lime, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
        }
    }
}

private struct MetricCard: View {
    var metric: ProgressMetric

    var body: some View {
        BoldCard(padding: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(metric.label.uppercased())
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .foregroundStyle(BoldPalette.ink.opacity(0.5))
                Text(metric.value)
                    .font(.boldDisplay(24))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(metric.delta)
                    .font(.boldBody(11))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Color(hex: metric.colorHex))
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(BoldPalette.ink, lineWidth: 2))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(viewModel: ProgressViewModel(appModel: AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: true)))
    }
}
