import SwiftUI

struct TodayView: View {
    @Bindable var viewModel: TodayViewModel

    var body: some View {
        BoldScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tuesday - Day \(viewModel.streakDays)")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(BoldPalette.ink.opacity(0.6))
                            Text("Hey \(viewModel.firstName)")
                                .font(.boldDisplay(38))
                        }
                        Spacer()
                        Sticker(text: "\(viewModel.streakDays) day streak", color: BoldPalette.hot, textColor: .white, rotation: 6)
                    }

                    BoldCard(background: BoldPalette.ink, radius: 22, shadow: 5) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("TODAY")
                                    .font(.boldBody(11))
                                    .foregroundStyle(BoldPalette.lime)
                                Text("\(viewModel.doneCount) of \(viewModel.tasks.count) done")
                                    .font(.boldDisplay(30))
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.75)
                            }
                            Spacer()
                            ProgressRing(progress: viewModel.progress)
                                .frame(width: 68, height: 68)
                        }
                    }

                    VStack(spacing: 10) {
                        ForEach(viewModel.tasks) { task in
                            DoseTaskRow(task: task) {
                                viewModel.toggle(task)
                            }
                        }
                    }

                    BoldCard(background: BoldPalette.hot) {
                        Sticker(text: "AI tip", color: BoldPalette.lime, rotation: -5, size: .small)
                        Text(viewModel.insight)
                            .font(.boldBody(16))
                            .foregroundStyle(.white)
                            .lineSpacing(3)
                            .padding(.top, 4)
                    }
                }
                .padding(20)
                .padding(.bottom, 20)
            }
        }
    }
}

private struct DoseTaskRow: View {
    var task: DoseTask
    var onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: task.icon)
                    .font(.system(size: 21, weight: .black))
                    .frame(width: 44, height: 44)
                    .background(Color(hex: task.colorHex))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(BoldPalette.ink, lineWidth: 2.5))
                VStack(alignment: .leading, spacing: 3) {
                    Text(task.name)
                        .font(.boldBody(17))
                        .strikethrough(task.isDone, color: BoldPalette.ink)
                        .opacity(task.isDone ? 0.5 : 1)
                    Text("\(task.dose) - \(task.time)")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(BoldPalette.ink.opacity(0.68))
                }
                Spacer()
                Image(systemName: task.isDone ? "checkmark" : "plus")
                    .font(.system(size: 17, weight: .black))
                    .foregroundStyle(task.isDone ? BoldPalette.lime : BoldPalette.ink)
                    .frame(width: 36, height: 36)
                    .background(task.isDone ? BoldPalette.ink : .white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(BoldPalette.ink, lineWidth: 2.5))
            }
            .padding(14)
            .background(task.isDue ? BoldPalette.lime : .white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(BoldPalette.ink, lineWidth: 3))
            .shadow(color: BoldPalette.ink, radius: 0, x: task.isDue ? 4 : 2, y: task.isDue ? 4 : 2)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(task.name), \(task.dose), \(task.time)")
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView(viewModel: TodayViewModel(appModel: AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: true)))
    }
}
