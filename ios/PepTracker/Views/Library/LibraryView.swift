import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Peptide> { !$0.archived }, sort: \Peptide.name)
    private var peptides: [Peptide]

    @State private var presentingAdd = false

    var body: some View {
        NavigationStack {
            Group {
                if peptides.isEmpty {
                    EmptyStateView(
                        title: "Build your library",
                        message: "Add the peptides you use so you can log doses, schedule protocols, and track vials.",
                        systemImage: "syringe",
                        actionTitle: "Add peptide",
                        action: { presentingAdd = true }
                    )
                } else {
                    List {
                        ForEach(peptides) { peptide in
                            NavigationLink(value: peptide) {
                                PeptideRow(peptide: peptide)
                            }
                        }
                        .onDelete(perform: archive)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Library")
            .navigationDestination(for: Peptide.self) { peptide in
                PeptideDetailView(peptide: peptide)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add peptide")
                }
            }
            .sheet(isPresented: $presentingAdd) {
                AddPeptideView()
            }
        }
    }

    private func archive(at offsets: IndexSet) {
        for i in offsets {
            peptides[i].archived = true
        }
        try? context.save()
    }
}

private struct PeptideRow: View {
    let peptide: Peptide

    private var activeProtocols: Int {
        peptide.protocols.filter(\.isActive).count
    }

    var body: some View {
        HStack(spacing: 12) {
            PeptideBadge(symbolName: peptide.symbolName, colorHex: peptide.colorHex, size: 44)
            VStack(alignment: .leading, spacing: 2) {
                Text(peptide.name)
                    .font(.headline)
                HStack(spacing: 6) {
                    Text("\(DoseFormatter.formatMcg(peptide.defaultDoseMcg)) default")
                    if activeProtocols > 0 {
                        Text("·")
                        Text("\(activeProtocols) active")
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            Spacer()
            if let days = peptide.daysUntilExpiry {
                ExpiryPill(daysRemaining: days)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct ExpiryPill: View {
    let daysRemaining: Int

    private var tint: Color {
        if daysRemaining <= 0 { return .red }
        if daysRemaining <= 5 { return .orange }
        return .green
    }

    private var label: String {
        if daysRemaining <= 0 { return "Expired" }
        if daysRemaining == 1 { return "1 day" }
        return "\(daysRemaining) days"
    }

    var body: some View {
        Text(label)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(tint.opacity(0.15), in: Capsule())
            .foregroundStyle(tint)
    }
}

#Preview {
    LibraryView()
        .modelContainer(SampleData.makeInMemoryContainer())
}
