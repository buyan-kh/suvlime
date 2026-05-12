import SwiftUI

struct StackView: View {
    @Bindable var viewModel: StackViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        BoldScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 8) {
                            Sticker(text: "Your stack", color: BoldPalette.lime, size: .small)
                            Text("\(viewModel.items.count) things.")
                                .font(.boldDisplay(38))
                        }
                        Spacer()
                        Button {
                            viewModel.openStackBuilder()
                        } label: {
                            Image(systemName: "plus")
                                .font(.boldDisplay(28))
                                .foregroundStyle(.white)
                                .frame(width: 48, height: 48)
                                .background(BoldPalette.ink)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Add supplement")
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(title: "All", isSelected: viewModel.selectedKind == nil) { viewModel.selectedKind = nil }
                            ForEach([SupplementKind.peptide, .glp1, .supplement, .longevity]) { kind in
                                FilterChip(title: kind.rawValue, isSelected: viewModel.selectedKind == kind) { viewModel.selectedKind = kind }
                            }
                        }
                    }

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.items) { item in
                            StackItemCard(item: item)
                        }
                    }

                    StackDetailCard(item: viewModel.featured, result: viewModel.reconstitution)
                }
                .padding(20)
                .padding(.bottom, 20)
            }
        }
    }
}

private struct FilterChip: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.boldBody(13))
                .foregroundStyle(isSelected ? .white : BoldPalette.ink)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? BoldPalette.ink : .white, in: Capsule())
                .overlay(Capsule().stroke(BoldPalette.ink, lineWidth: 2.5))
        }
        .buttonStyle(.plain)
    }
}

private struct StackItemCard: View {
    var item: SupplementItem

    var body: some View {
        BoldCard(padding: 14) {
            VStack(alignment: .leading, spacing: 9) {
                Image(systemName: item.icon)
                    .font(.system(size: 23, weight: .black))
                    .frame(width: 48, height: 48)
                    .background(Color(hex: item.colorHex))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(BoldPalette.ink, lineWidth: 2.5))
                Text(item.name)
                    .font(.boldBody(17))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(item.kind.rawValue)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(BoldPalette.ink.opacity(0.62))
                HStack {
                    Text(item.dayLabel)
                        .font(.boldBody(11))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(BoldPalette.ink)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    Spacer()
                    EvidenceStars(count: item.evidence)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 152, alignment: .leading)
        }
    }
}

private struct StackDetailCard: View {
    var item: SupplementItem
    var result: ReconstitutionResult

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Sticker(text: "Math done for you", color: BoldPalette.lime, rotation: 3, size: .small)
            Text("Mix the vial.")
                .font(.boldDisplay(40))
            HStack(spacing: 12) {
                MiniMetric(label: "Peptide", value: "\(Int(item.vialMg ?? 0)) mg", color: .white)
                MiniMetric(label: "BAC water", value: "\(Int(item.bacWaterMl ?? 0)) mL", color: .white)
                MiniMetric(label: "Dose", value: "\(Int(item.targetDoseMcg ?? 0)) mcg", color: .white)
            }
            BoldCard(background: BoldPalette.ink, radius: 20, shadow: 5) {
                Text("DRAW THIS MUCH")
                    .font(.boldBody(12))
                    .foregroundStyle(BoldPalette.lime)
                HStack(alignment: .lastTextBaseline, spacing: 8) {
                    Text("\(Int(result.syringeUnits.rounded()))")
                        .font(.boldDisplay(88))
                        .foregroundStyle(BoldPalette.lime)
                    Text("ticks")
                        .font(.boldBody(22))
                        .foregroundStyle(.white)
                }
                Text("on a U-100 insulin syringe")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding(.top, 8)
    }
}

private struct MiniMetric: View {
    var label: String
    var value: String
    var color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 9, weight: .black, design: .rounded))
                .foregroundStyle(BoldPalette.ink.opacity(0.6))
            Text(value)
                .font(.boldBody(16))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(BoldPalette.ink, lineWidth: 2.5))
    }
}

struct StackView_Previews: PreviewProvider {
    static var previews: some View {
        StackView(viewModel: StackViewModel(appModel: AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: true)))
    }
}
