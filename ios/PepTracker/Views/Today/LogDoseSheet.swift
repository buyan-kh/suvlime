import SwiftUI
import SwiftData

struct LogDoseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Peptide> { !$0.archived }, sort: \Peptide.name)
    private var peptides: [Peptide]

    let context: DoseLogContext

    @State private var selectedPeptide: Peptide?
    @State private var protocolId: UUID?
    @State private var doseMcg: Double = 250
    @State private var doseText: String = "250"
    @State private var takenAt: Date = .now
    @State private var site: InjectionSite?
    @State private var route: AdministrationRoute = .subcutaneous
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Peptide") {
                    Picker("Peptide", selection: peptideBinding) {
                        Text("Choose…").tag(Optional<Peptide>(nil))
                        ForEach(peptides) { p in
                            Text(p.name).tag(Optional(p))
                        }
                    }
                }

                Section("Dose") {
                    HStack {
                        TextField("Amount", text: $doseText)
                            .keyboardType(.decimalPad)
                            .onChange(of: doseText) { _, new in
                                if let v = Double(new.replacingOccurrences(of: ",", with: ".")) {
                                    doseMcg = v
                                }
                            }
                        Text("mcg")
                            .foregroundStyle(.secondary)
                    }
                    if let calc = liveCalculation {
                        LabeledContent("On syringe") {
                            Text("\(DoseFormatter.formatUnits(calc.syringeUnits)) · \(DoseFormatter.formatMl(calc.volumeMl))")
                                .monospacedDigit()
                        }
                    }
                    DatePicker("Taken at", selection: $takenAt)
                }

                Section("Administration") {
                    Picker("Route", selection: $route) {
                        ForEach(AdministrationRoute.allCases) { r in
                            Text(r.displayName).tag(r)
                        }
                    }
                    Picker("Injection site", selection: siteBinding) {
                        Text("None").tag(Optional<InjectionSite>(nil))
                        ForEach(InjectionSite.allCases) { s in
                            Text(s.displayName).tag(Optional(s))
                        }
                    }
                }

                Section("Notes") {
                    TextField("Optional", text: $notes, axis: .vertical)
                        .lineLimit(2...5)
                }
            }
            .navigationTitle("Log Dose")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: save)
                        .fontWeight(.semibold)
                        .disabled(selectedPeptide == nil || doseMcg <= 0)
                }
            }
            .onAppear(perform: applyContext)
        }
    }

    private var peptideBinding: Binding<Peptide?> {
        Binding(
            get: { selectedPeptide },
            set: { newValue in
                selectedPeptide = newValue
                if let p = newValue {
                    doseMcg = p.defaultDoseMcg
                    doseText = String(p.defaultDoseMcg.cleanString)
                    route = p.route
                }
            }
        )
    }

    private var siteBinding: Binding<InjectionSite?> {
        Binding(get: { site }, set: { site = $0 })
    }

    private var liveCalculation: ReconstitutionCalculator.Result? {
        guard let p = selectedPeptide else { return nil }
        return ReconstitutionCalculator.calculate(
            doseMcg: doseMcg,
            vialMg: p.vialSizeMg,
            bacWaterMl: p.bacWaterMl
        )
    }

    private func applyContext() {
        switch context {
        case .fromProtocol(let proto, let scheduledAt):
            selectedPeptide = proto.peptide
            protocolId = proto.id
            doseMcg = proto.doseMcg
            doseText = proto.doseMcg.cleanString
            site = proto.defaultSite
            route = proto.route
            takenAt = scheduledAt > .now ? .now : scheduledAt
        case .freeform:
            if selectedPeptide == nil, let first = peptides.first {
                selectedPeptide = first
                doseMcg = first.defaultDoseMcg
                doseText = first.defaultDoseMcg.cleanString
                route = first.route
            }
        }
    }

    private func save() {
        guard let peptide = selectedPeptide else { return }
        let calc = ReconstitutionCalculator.calculate(
            doseMcg: doseMcg,
            vialMg: peptide.vialSizeMg,
            bacWaterMl: peptide.bacWaterMl
        )
        let log = DoseLog(
            peptide: peptide,
            protocolId: protocolId,
            takenAt: takenAt,
            doseMcg: doseMcg,
            volumeMl: calc.volumeMl,
            syringeUnits: calc.syringeUnits,
            site: site,
            route: route,
            notes: notes
        )
        modelContext.insert(log)
        try? modelContext.save()
        dismiss()
    }
}

extension Double {
    /// Formats a double without trailing zeros for editable text fields.
    var cleanString: String {
        if self == rounded() { return String(Int(self)) }
        return String(self)
    }
}

#Preview {
    LogDoseSheet(context: .freeform)
        .modelContainer(SampleData.makeInMemoryContainer())
}
