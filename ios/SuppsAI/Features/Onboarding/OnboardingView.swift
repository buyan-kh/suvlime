import SwiftUI

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        ZStack {
            switch viewModel.step {
            case 0:
                HeroStep { viewModel.next() }
            case 1:
                SocialProofStep { viewModel.next() }
            case 2:
                TakingStep(viewModel: viewModel)
            case 3:
                GoalStep(viewModel: viewModel)
            case 4:
                CommitmentStep(viewModel: viewModel)
            default:
                RevealStep(viewModel: viewModel)
            }
        }
        .sheet(isPresented: $viewModel.showingPaywall) {
            PaywallView(onClose: viewModel.finish)
        }
    }
}

private struct HeroStep: View {
    var onNext: () -> Void

    var body: some View {
        BoldScreen(background: BoldPalette.lime) {
            VStack(alignment: .leading, spacing: 22) {
                Spacer(minLength: 24)
                ZStack(alignment: .topTrailing) {
                    Text("Take\nyour stuff.\nGet gains.")
                        .font(.boldDisplay(72))
                        .lineSpacing(-14)
                        .minimumScaleFactor(0.78)
                        .overlay(alignment: .bottomLeading) {
                            Text("Get gains.")
                                .font(.boldDisplay(56))
                                .foregroundStyle(BoldPalette.lime)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 2)
                                .background(BoldPalette.ink)
                                .rotationEffect(.degrees(-2))
                                .offset(y: 1)
                        }
                    PillMascot(size: 136)
                        .rotationEffect(.degrees(10))
                        .offset(x: 28, y: 92)
                }
                Text("The dumb-simple app for peptides, GLP-1s, and supplements. Your AI coach lives inside.")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .lineSpacing(3)
                    .frame(maxWidth: 326, alignment: .leading)
                Spacer()
                HStack(spacing: 10) {
                    OverlapDots(colors: [BoldPalette.hot, BoldPalette.sky, BoldPalette.butter, BoldPalette.pink])
                    Text("100,000+ stackers\n4.9 on App Store")
                        .font(.system(size: 13, weight: .black, design: .rounded))
                        .lineSpacing(2)
                }
                BoldButton(title: "Let's go", systemImage: "arrow.right", action: onNext)
                Button("I already have an account", action: onNext)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(BoldPalette.ink.opacity(0.6))
            }
            .padding(.horizontal, 28)
            .padding(.top, 28)
            .padding(.bottom, 26)
        }
    }
}

private struct SocialProofStep: View {
    var onNext: () -> Void

    private let quotes = [
        ("Marcus, 34", "Lost 22 lbs on sema. SuppsAI showed me my plateau before it hit.", BoldPalette.hot),
        ("Priya, 29", "My peptide stack used to be a mess. Now I know what to take and when.", BoldPalette.sky),
        ("Jordan, 41", "My doc liked that I came in with 6 months of clean notes.", BoldPalette.butter)
    ]

    var body: some View {
        BoldScreen {
            VStack(alignment: .leading, spacing: 16) {
                StepHeader(step: 2, total: 6)
                Sticker(text: "4.9 stars", color: BoldPalette.lime)
                Text("100,000\nstackers\nlove it.")
                    .font(.boldDisplay(48))
                    .lineSpacing(-8)
                VStack(spacing: 12) {
                    ForEach(Array(quotes.enumerated()), id: \.offset) { index, quote in
                        BoldCard {
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(quote.2)
                                    .overlay(Circle().stroke(BoldPalette.ink, lineWidth: 2.5))
                                    .frame(width: 36, height: 36)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(quote.0).font(.boldBody(13))
                                    Text("★★★★★").font(.system(size: 10, weight: .black)).foregroundStyle(BoldPalette.hot)
                                }
                            }
                            Text(quote.1)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .lineSpacing(3)
                                .padding(.top, 4)
                        }
                        .rotationEffect(.degrees(index.isMultiple(of: 2) ? -0.6 : 0.8))
                    }
                }
                Spacer()
                BoldButton(title: "Keep going", systemImage: "arrow.right", background: BoldPalette.lime, foreground: BoldPalette.ink, action: onNext)
            }
            .padding(22)
        }
    }
}

private struct TakingStep: View {
    @Bindable var viewModel: OnboardingViewModel

    private let options = [
        ("Peptides", "syringe.fill"),
        ("Pills", "pills.fill"),
        ("GLP-1s", "drop.fill"),
        ("Brain stuff", "brain.head.profile"),
        ("Hormones", "waveform.path.ecg"),
        ("Vitamins", "leaf.fill")
    ]

    var body: some View {
        ChoiceStep(
            step: 3,
            total: viewModel.totalSteps,
            title: "What do\nyou take?",
            subtitle: "Pick all that match. We'll do the math.",
            background: BoldPalette.paper,
            options: options,
            selected: viewModel.selectedTaking,
            buttonTitle: "Keep going"
        ) { item in
            if viewModel.selectedTaking.contains(item) {
                viewModel.selectedTaking.remove(item)
            } else {
                viewModel.selectedTaking.insert(item)
            }
        } onNext: {
            viewModel.next()
        }
    }
}

private struct GoalStep: View {
    @Bindable var viewModel: OnboardingViewModel

    private let options = [
        ("Burn fat", "flame.fill"),
        ("Build muscle", "dumbbell.fill"),
        ("Sleep better", "moon.zzz.fill"),
        ("Live longer", "sparkles"),
        ("More energy", "bolt.fill"),
        ("Heal injury", "cross.case.fill")
    ]

    var body: some View {
        ChoiceStep(
            step: 4,
            total: viewModel.totalSteps,
            title: "What's the\nbig goal?",
            subtitle: "Pick 1 or 2. Be honest.",
            background: BoldPalette.sky,
            options: options,
            selected: viewModel.selectedGoals,
            buttonTitle: "Next"
        ) { item in
            if viewModel.selectedGoals.contains(item) {
                viewModel.selectedGoals.remove(item)
            } else if viewModel.selectedGoals.count < 2 {
                viewModel.selectedGoals.insert(item)
            }
        } onNext: {
            viewModel.next()
        }
    }
}

private struct CommitmentStep: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        BoldScreen(background: BoldPalette.hot) {
            VStack(alignment: .leading, spacing: 18) {
                StepHeader(step: 5, total: viewModel.totalSteps, buttonBackground: BoldPalette.paper)
                Text("How serious\nare you?")
                    .font(.boldDisplay(48))
                    .foregroundStyle(.white)
                    .lineSpacing(-8)
                Text("Slide it. No judgement.")
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
                ZStack {
                    Text("\(Int(viewModel.seriousness))")
                        .font(.boldDisplay(230))
                        .foregroundStyle(BoldPalette.ink)
                        .minimumScaleFactor(0.7)
                    Sticker(text: "Beast mode", color: BoldPalette.lime, rotation: 6, size: .large)
                        .offset(x: 92, y: -86)
                }
                BoldCard(background: .white) {
                    HStack {
                        Text("Casual")
                        Spacer()
                        Text("All in")
                    }
                    .font(.boldBody(12))
                    Slider(value: $viewModel.seriousness, in: 1...10, step: 1)
                        .tint(BoldPalette.lime)
                    Text("People at 8+ see better follow-through.")
                        .font(.boldBody(11))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(BoldPalette.lime)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                BoldButton(title: "I'm ready", systemImage: "arrow.right", background: BoldPalette.lime, foreground: BoldPalette.ink) {
                    viewModel.next()
                }
            }
            .padding(22)
        }
    }
}

private struct RevealStep: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        BoldScreen {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Sticker(text: "Your plan", color: BoldPalette.lime)
                    Spacer()
                    Text("Built in 4 sec")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(BoldPalette.ink.opacity(0.6))
                }
                Text("Hey Alex -\nyour score\ncould 2.6x")
                    .font(.boldDisplay(44))
                    .lineSpacing(-7)
                BoldCard(background: BoldPalette.ink) {
                    HStack(alignment: .lastTextBaseline) {
                        VStack(alignment: .leading) {
                            Text("NOW").font(.boldBody(11)).foregroundStyle(BoldPalette.lime)
                            Text("34").font(.boldDisplay(56)).foregroundStyle(.white)
                        }
                        Spacer()
                        Text("->").font(.boldDisplay(32)).foregroundStyle(.white.opacity(0.55))
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("WITH SUPPSAI").font(.boldBody(11)).foregroundStyle(BoldPalette.lime)
                            Text("89").font(.boldDisplay(56)).foregroundStyle(BoldPalette.lime)
                        }
                    }
                    Sparkline(points: [0.15, 0.2, 0.32, 0.36, 0.52, 0.7, 0.88], color: BoldPalette.lime)
                        .frame(height: 54)
                }
                BoldCard(background: BoldPalette.lime) {
                    Sticker(text: "1st insight", color: BoldPalette.hot, textColor: .white, rotation: -6, size: .small)
                    Text("Your BPC-157 + TB-500 timing is off by about 4 hours. Easy fix.")
                        .font(.boldBody(17))
                        .lineSpacing(3)
                        .padding(.top, 4)
                }
                Spacer()
                BoldButton(title: "Show me how", systemImage: "arrow.right") {
                    viewModel.showingPaywall = true
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 62)
            .padding(.bottom, 24)
        }
    }
}

private struct ChoiceStep: View {
    var step: Int
    var total: Int
    var title: String
    var subtitle: String
    var background: Color
    var options: [(String, String)]
    var selected: Set<String>
    var buttonTitle: String
    var onSelect: (String) -> Void
    var onNext: () -> Void

    var body: some View {
        BoldScreen(background: background) {
            VStack(alignment: .leading, spacing: 18) {
                StepHeader(step: step, total: total)
                Text(title)
                    .font(.boldDisplay(48))
                    .lineSpacing(-8)
                Text(subtitle)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(BoldPalette.ink.opacity(0.72))
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(options, id: \.0) { option in
                        Button {
                            onSelect(option.0)
                        } label: {
                            BoldTile(title: option.0, systemImage: option.1, selected: selected.contains(option.0))
                        }
                        .buttonStyle(.plain)
                    }
                }
                Spacer()
                BoldButton(title: buttonTitle, systemImage: "arrow.right", background: BoldPalette.lime, foreground: BoldPalette.ink, action: onNext)
            }
            .padding(22)
        }
    }
}

struct StepHeader: View {
    var step: Int
    var total: Int
    var buttonBackground: Color = .white

    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .black))
                .frame(width: 44, height: 44)
                .background(buttonBackground)
                .clipShape(Circle())
                .overlay(Circle().stroke(BoldPalette.ink, lineWidth: 2.5))
            Spacer()
            Text("\(step) / \(total)")
                .font(.boldBody(13))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(BoldPalette.ink, in: Capsule())
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Step \(step) of \(total)")
    }
}

private struct OverlapDots: View {
    var colors: [Color]

    var body: some View {
        HStack(spacing: -8) {
            ForEach(Array(colors.enumerated()), id: \.offset) { _, color in
                Circle()
                    .fill(color)
                    .overlay(Circle().stroke(BoldPalette.ink, lineWidth: 2.5))
                    .frame(width: 32, height: 32)
            }
        }
    }
}

struct Sparkline: View {
    var points: [Double]
    var color: Color

    var body: some View {
        GeometryReader { proxy in
            Path { path in
                guard let first = points.first else { return }
                let height = proxy.size.height
                let width = proxy.size.width
                path.move(to: CGPoint(x: 0, y: height * (1 - first)))
                for index in points.indices {
                    let x = width * CGFloat(index) / CGFloat(max(points.count - 1, 1))
                    let y = height * CGFloat(1 - points[index])
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: OnboardingViewModel(appModel: AppViewModel(seed: MockSuppsData.seed)))
    }
}
