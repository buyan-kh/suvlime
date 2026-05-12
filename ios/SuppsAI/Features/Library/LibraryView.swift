import SwiftUI

struct LibraryView: View {
    @Bindable var viewModel: LibraryViewModel

    var body: some View {
        BoldScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Sticker(text: "The library", color: BoldPalette.lime, size: .small)
                    Text("Look it up.")
                        .font(.boldDisplay(38))
                    Text("200+ compounds - plain-English summaries")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(BoldPalette.ink.opacity(0.62))

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 17, weight: .black))
                        TextField("Search BPC, NAD, GLP-1...", text: $viewModel.query)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                    }
                    .padding(14)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(BoldPalette.ink, lineWidth: 3))
                    .shadow(color: BoldPalette.ink, radius: 0, x: 3, y: 3)

                    HStack {
                        Text("Hot this week")
                            .font(.boldBody(16))
                        Spacer()
                        Text("See all")
                            .font(.boldBody(12))
                            .foregroundStyle(BoldPalette.ink.opacity(0.5))
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.trending) { compound in
                                TrendingCompoundCard(compound: compound)
                            }
                        }
                        .padding(.bottom, 6)
                    }

                    HStack(spacing: 6) {
                        ForEach(["All", "Peptides", "GLP-1", "Supps"], id: \.self) { chip in
                            Text(chip)
                                .font(.boldBody(12))
                                .foregroundStyle(chip == "All" ? .white : BoldPalette.ink)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(chip == "All" ? BoldPalette.ink : .white, in: Capsule())
                                .overlay(Capsule().stroke(BoldPalette.ink, lineWidth: 2.5))
                        }
                    }

                    VStack(spacing: 8) {
                        ForEach(viewModel.compounds) { compound in
                            CompoundRow(compound: compound)
                        }
                    }
                }
                .padding(22)
                .padding(.bottom, 20)
            }
        }
    }
}

private struct TrendingCompoundCard: View {
    var compound: ResearchCompound

    var body: some View {
        BoldCard(radius: 16, padding: 12) {
            VStack(alignment: .leading, spacing: 8) {
                if let tag = compound.tag {
                    Sticker(text: tag, color: BoldPalette.hot, textColor: .white, rotation: 4, size: .small)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Image(systemName: "testtube.2")
                    .font(.system(size: 20, weight: .black))
                    .frame(width: 42, height: 42)
                    .background(Color(hex: compound.colorHex))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(BoldPalette.ink, lineWidth: 2.5))
                Text(compound.name)
                    .font(.boldBody(17))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(compound.kind.rawValue)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(BoldPalette.ink.opacity(0.6))
                EvidenceStars(count: compound.evidence)
            }
            .frame(width: 160, alignment: .leading)
        }
    }
}

private struct CompoundRow: View {
    var compound: ResearchCompound

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "testtube.2")
                .font(.system(size: 18, weight: .black))
                .frame(width: 40, height: 40)
                .background(Color(hex: compound.colorHex))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(BoldPalette.ink, lineWidth: 2))
            VStack(alignment: .leading, spacing: 2) {
                Text(compound.name).font(.boldBody(16))
                Text(compound.summary)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(BoldPalette.ink.opacity(0.62))
                    .lineLimit(2)
            }
            Spacer()
            EvidenceStars(count: compound.evidence)
            Image(systemName: "chevron.right").font(.boldBody(13))
        }
        .padding(12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(BoldPalette.ink, lineWidth: 2.5))
    }
}

struct EvidenceStars: View {
    var count: Int

    var body: some View {
        Text(String(repeating: "★", count: count))
            .font(.system(size: 12, weight: .black))
            .foregroundStyle(BoldPalette.hot)
            .accessibilityLabel("\(count) star evidence")
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(viewModel: LibraryViewModel(appModel: AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: true)))
    }
}
