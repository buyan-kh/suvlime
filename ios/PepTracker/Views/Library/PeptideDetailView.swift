import SwiftUI
import SwiftData

struct PeptideDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var peptide: Peptide

    @State private var presentingEdit = false
    @State private var presentingProtocol = false
    @State private var editingProtocol: DosingProtocol?

    private var doses: [DoseLog] {
        peptide.doses.sorted { $0.takenAt > $1.takenAt }
    }

    private var protocols: [DosingProtocol] {
        peptide.protocols.sorted { $0.timeOfDay < $1.timeOfDay }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroCard
                vialCard
                protocolsSection
                historySection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(peptide.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { presentingEdit = true }
            }
        }
        .sheet(isPresented: $presentingEdit) {
            AddPeptideView(existing: peptide)
        }
        .sheet(isPresented: $presentingProtocol) {
            ProtocolEditorView(peptide: peptide)
        }
        .sheet(item: $editingProtocol) { proto in
            ProtocolEditorView(peptide: peptide, existing: proto)
        }
    }

    // MARK: – Hero

    private var heroCard: some View {
        let calc = ReconstitutionCalculator.calculate(
            doseMcg: peptide.defaultDoseMcg,
            vialMg: peptide.vialSizeMg,
            bacWaterMl: peptide.bacWaterMl
        )

        return VStack(spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                PeptideBadge(symbolName: peptide.symbolName, colorHex: peptide.colorHex, size: 56)
                VStack(alignment: .leading, spacing: 4) {
                    Text(peptide.name)
                        .font(.title3.weight(.bold))
                    if !peptide.details.isEmpty {
                        Text(peptide.details)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }
                }
                Spacer()
            }
            Divider()
            HStack(spacing: 0) {
                StatCell(label: "Default", value: DoseFormatter.formatMcg(peptide.defaultDoseMcg))
                StatCell(label: "Per dose", value: DoseFormatter.formatUnits(calc.syringeUnits))
                StatCell(label: "Volume", value: DoseFormatter.formatMl(calc.volumeMl))
            }
        }
        .card()
    }

    // MARK: – Vial

    private var vialCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Vial")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                if peptide.vialOpenedAt == nil {
                    Button("Mark opened") {
                        peptide.vialOpenedAt = .now
                        try? modelContext.save()
                    }
                    .font(.subheadline.weight(.semibold))
                } else {
                    Button("Reset") {
                        peptide.vialOpenedAt = nil
                        try? modelContext.save()
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 0) {
                StatCell(label: "Size", value: "\(peptide.vialSizeMg.cleanString) mg")
                StatCell(label: "BAC water", value: "\(peptide.bacWaterMl.cleanString) mL")
                StatCell(label: "Conc.", value: DoseFormatter.formatConcentration(peptide.concentrationMcgPerMl))
            }

            if let opened = peptide.vialOpenedAt {
                let days = peptide.daysUntilExpiry ?? 0
                let progress = min(1.0, max(0, Double(peptide.stabilityDays - max(days, 0)) / Double(peptide.stabilityDays)))
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Opened \(opened, format: .relative(presentation: .named))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(days <= 0 ? "Expired" : "\(days) day\(days == 1 ? "" : "s") left")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(days <= 5 ? .orange : .secondary)
                    }
                    ProgressView(value: progress)
                        .tint(days <= 5 ? .orange : .accentColor)
                }
            }
        }
        .card()
    }

    // MARK: – Protocols

    private var protocolsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Protocols")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Button {
                    presentingProtocol = true
                } label: {
                    Label("Add", systemImage: "plus")
                        .font(.subheadline.weight(.semibold))
                }
            }
            .padding(.horizontal, 4)

            if protocols.isEmpty {
                Text("No protocols yet — add one to schedule reminders.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .card()
            } else {
                VStack(spacing: 10) {
                    ForEach(protocols) { proto in
                        Button {
                            editingProtocol = proto
                        } label: {
                            ProtocolRow(proto: proto)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: – History

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent doses")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            if doses.isEmpty {
                Text("No doses logged yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .card()
            } else {
                VStack(spacing: 10) {
                    ForEach(doses.prefix(8)) { log in
                        HistoryRow(log: log)
                    }
                }
            }
        }
    }
}

// MARK: – Building blocks

private struct StatCell: View {
    let label: String
    let value: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.headline).monospacedDigit()
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ProtocolRow: View {
    let proto: DosingProtocol

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: proto.isActive ? "bell.fill" : "bell.slash")
                .foregroundStyle(proto.isActive ? Color.accentColor : .secondary)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 2) {
                Text(proto.name)
                    .font(.headline)
                HStack(spacing: 6) {
                    Text(DoseFormatter.formatMcg(proto.doseMcg))
                    Text("·")
                    Text(proto.frequency.displayName)
                    Text("·")
                    Text(DateDisplay.timeOfDay.string(from: proto.timeOfDay))
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .card(padding: 14)
    }
}

private struct HistoryRow: View {
    let log: DoseLog

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: log.skipped ? "xmark.circle.fill" : "checkmark.circle.fill")
                .foregroundStyle(log.skipped ? Color.orange : Color.green)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(DateDisplay.shortDateTime.string(from: log.takenAt))
                        .font(.subheadline.weight(.medium))
                    if log.skipped {
                        Text("Skipped")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.orange)
                    }
                }
                if !log.skipped {
                    HStack(spacing: 6) {
                        Text(DoseFormatter.formatMcg(log.doseMcg))
                        Text("·")
                        Text(DoseFormatter.formatUnits(log.syringeUnits))
                        if let site = log.site {
                            Text("·")
                            Text(site.displayName).lineLimit(1)
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .card(padding: 12)
    }
}

#Preview {
    NavigationStack {
        PeptideDetailView(peptide: previewPeptide())
    }
    .modelContainer(SampleData.makeInMemoryContainer())
}

@MainActor
private func previewPeptide() -> Peptide {
    let container = SampleData.makeInMemoryContainer()
    let descriptor = FetchDescriptor<Peptide>()
    return (try? container.mainContext.fetch(descriptor).first)
        ?? Peptide(name: "Sample")
}
