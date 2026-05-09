import SwiftUI
import SwiftData

struct AddPeptideView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var existing: Peptide?

    @State private var name: String = ""
    @State private var details: String = ""
    @State private var vialSizeMg: Double = 5
    @State private var vialSizeText: String = "5"
    @State private var bacWaterMl: Double = 2
    @State private var bacWaterText: String = "2"
    @State private var defaultDoseMcg: Double = 250
    @State private var defaultDoseText: String = "250"
    @State private var route: AdministrationRoute = .subcutaneous
    @State private var colorHex: String = Palette.peptideTags[0]
    @State private var symbolName: String = "syringe.fill"
    @State private var trackVial: Bool = false
    @State private var vialOpenedAt: Date = .now
    @State private var stabilityDays: Int = 30

    private let symbolChoices = [
        "syringe.fill", "leaf.fill", "bolt.heart.fill", "drop.fill",
        "flask.fill", "pills.fill", "cross.vial.fill", "sparkles"
    ]

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && vialSizeMg > 0
        && bacWaterMl > 0
        && defaultDoseMcg > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Identity") {
                    TextField("Name", text: $name)
                        .textInputAutocapitalization(.words)
                    TextField("Details (optional)", text: $details, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Vial") {
                    HStack {
                        TextField("Vial size", text: $vialSizeText)
                            .keyboardType(.decimalPad)
                            .onChange(of: vialSizeText) { _, new in
                                if let v = Double(new.replacingOccurrences(of: ",", with: ".")) { vialSizeMg = v }
                            }
                        Text("mg").foregroundStyle(.secondary)
                    }
                    HStack {
                        TextField("BAC water", text: $bacWaterText)
                            .keyboardType(.decimalPad)
                            .onChange(of: bacWaterText) { _, new in
                                if let v = Double(new.replacingOccurrences(of: ",", with: ".")) { bacWaterMl = v }
                            }
                        Text("mL").foregroundStyle(.secondary)
                    }
                    LabeledContent("Concentration") {
                        Text(DoseFormatter.formatConcentration(currentConcentration))
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }

                Section("Default dose") {
                    HStack {
                        TextField("Dose", text: $defaultDoseText)
                            .keyboardType(.decimalPad)
                            .onChange(of: defaultDoseText) { _, new in
                                if let v = Double(new.replacingOccurrences(of: ",", with: ".")) { defaultDoseMcg = v }
                            }
                        Text("mcg").foregroundStyle(.secondary)
                    }
                    LabeledContent("On syringe") {
                        Text(currentDoseSummary)
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    Picker("Route", selection: $route) {
                        ForEach(AdministrationRoute.allCases) { r in
                            Text(r.displayName).tag(r)
                        }
                    }
                }

                Section("Vial freshness") {
                    Toggle("Track reconstitution date", isOn: $trackVial.animation())
                    if trackVial {
                        DatePicker("Opened on", selection: $vialOpenedAt, displayedComponents: [.date])
                        Stepper("Stable for \(stabilityDays) days", value: $stabilityDays, in: 1...90)
                    }
                }

                Section("Appearance") {
                    ColorPickerStrip(selection: $colorHex)
                    SymbolPickerGrid(selection: $symbolName, options: symbolChoices)
                }
            }
            .navigationTitle(existing == nil ? "New Peptide" : "Edit Peptide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: save)
                        .fontWeight(.semibold)
                        .disabled(!isValid)
                }
            }
            .onAppear(perform: prefillIfEditing)
        }
    }

    private var currentConcentration: Double {
        guard bacWaterMl > 0 else { return 0 }
        return (vialSizeMg * 1000) / bacWaterMl
    }

    private var currentDoseSummary: String {
        let r = ReconstitutionCalculator.calculate(
            doseMcg: defaultDoseMcg,
            vialMg: vialSizeMg,
            bacWaterMl: bacWaterMl
        )
        return "\(DoseFormatter.formatUnits(r.syringeUnits)) · \(DoseFormatter.formatMl(r.volumeMl))"
    }

    private func prefillIfEditing() {
        guard let p = existing else { return }
        name = p.name
        details = p.details
        vialSizeMg = p.vialSizeMg
        vialSizeText = p.vialSizeMg.cleanString
        bacWaterMl = p.bacWaterMl
        bacWaterText = p.bacWaterMl.cleanString
        defaultDoseMcg = p.defaultDoseMcg
        defaultDoseText = p.defaultDoseMcg.cleanString
        route = p.route
        colorHex = p.colorHex
        symbolName = p.symbolName
        trackVial = p.vialOpenedAt != nil
        vialOpenedAt = p.vialOpenedAt ?? .now
        stabilityDays = p.stabilityDays
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if let p = existing {
            p.name = trimmedName
            p.details = details
            p.vialSizeMg = vialSizeMg
            p.bacWaterMl = bacWaterMl
            p.defaultDoseMcg = defaultDoseMcg
            p.route = route
            p.colorHex = colorHex
            p.symbolName = symbolName
            p.vialOpenedAt = trackVial ? vialOpenedAt : nil
            p.stabilityDays = stabilityDays
        } else {
            let new = Peptide(
                name: trimmedName,
                details: details,
                vialSizeMg: vialSizeMg,
                bacWaterMl: bacWaterMl,
                defaultDoseMcg: defaultDoseMcg,
                route: route,
                colorHex: colorHex,
                symbolName: symbolName,
                vialOpenedAt: trackVial ? vialOpenedAt : nil,
                stabilityDays: stabilityDays
            )
            modelContext.insert(new)
        }
        try? modelContext.save()
        dismiss()
    }
}

private struct ColorPickerStrip: View {
    @Binding var selection: String

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Palette.peptideTags, id: \.self) { hex in
                Button {
                    selection = hex
                } label: {
                    ZStack {
                        Circle().fill(Color(hex: hex))
                        if selection == hex {
                            Circle().stroke(Color.primary, lineWidth: 2)
                                .frame(width: 32, height: 32)
                        }
                    }
                    .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Color \(hex)")
            }
        }
        .padding(.vertical, 4)
    }
}

private struct SymbolPickerGrid: View {
    @Binding var selection: String
    let options: [String]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(options, id: \.self) { name in
                Button {
                    selection = name
                } label: {
                    Image(systemName: name)
                        .font(.title3)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selection == name ? Color.accentColor.opacity(0.18) : Color(.tertiarySystemFill))
                        )
                        .foregroundStyle(selection == name ? Color.accentColor : .primary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(name)
            }
        }
    }
}

#Preview {
    AddPeptideView()
        .modelContainer(SampleData.makeInMemoryContainer())
}
