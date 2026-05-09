import SwiftUI
import SwiftData

struct ReconstitutionView: View {
    @Query(filter: #Predicate<Peptide> { !$0.archived }, sort: \Peptide.name)
    private var peptides: [Peptide]

    @State private var preset: Peptide?
    @State private var vialMg: Double = 5
    @State private var vialText: String = "5"
    @State private var bacMl: Double = 2
    @State private var bacText: String = "2"
    @State private var doseMcg: Double = 250
    @State private var doseText: String = "250"

    private var calc: ReconstitutionCalculator.Result {
        ReconstitutionCalculator.calculate(
            doseMcg: doseMcg,
            vialMg: vialMg,
            bacWaterMl: bacMl
        )
    }

    private var dosesPerVial: Int {
        ReconstitutionCalculator.dosesPerVial(doseMcg: doseMcg, vialMg: vialMg)
    }

    var body: some View {
        NavigationStack {
            Form {
                if !peptides.isEmpty {
                    Section("Quick fill") {
                        Picker("From peptide", selection: presetBinding) {
                            Text("None").tag(Optional<Peptide>(nil))
                            ForEach(peptides) { p in
                                Text(p.name).tag(Optional(p))
                            }
                        }
                    }
                }

                Section("Vial") {
                    InputRow(label: "Vial size", text: $vialText, value: $vialMg, unit: "mg")
                    InputRow(label: "BAC water", text: $bacText, value: $bacMl, unit: "mL")
                }

                Section("Dose") {
                    InputRow(label: "Dose", text: $doseText, value: $doseMcg, unit: "mcg")
                }

                Section {
                    ResultBlock(calc: calc, dosesPerVial: dosesPerVial)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }

                Section {
                    DisclosureGroup("How this is calculated") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Concentration = (Vial mg × 1000) ÷ BAC water mL")
                            Text("Volume = Dose mcg ÷ Concentration")
                            Text("Units assumes a U-100 insulin syringe (100 units per mL).")
                                .foregroundStyle(.secondary)
                        }
                        .font(.footnote)
                    }
                }
            }
            .navigationTitle("Calculator")
        }
    }

    private var presetBinding: Binding<Peptide?> {
        Binding(
            get: { preset },
            set: { newValue in
                preset = newValue
                if let p = newValue {
                    vialMg = p.vialSizeMg
                    vialText = p.vialSizeMg.cleanString
                    bacMl = p.bacWaterMl
                    bacText = p.bacWaterMl.cleanString
                    doseMcg = p.defaultDoseMcg
                    doseText = p.defaultDoseMcg.cleanString
                }
            }
        )
    }
}

private struct InputRow: View {
    let label: String
    @Binding var text: String
    @Binding var value: Double
    let unit: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField("0", text: $text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .onChange(of: text) { _, new in
                    if let v = Double(new.replacingOccurrences(of: ",", with: ".")) { value = v }
                }
                .frame(maxWidth: 120)
            Text(unit).foregroundStyle(.secondary).frame(width: 36, alignment: .leading)
        }
    }
}

private struct ResultBlock: View {
    let calc: ReconstitutionCalculator.Result
    let dosesPerVial: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                ResultStat(value: DoseFormatter.formatUnits(calc.syringeUnits), label: "On syringe", emphasis: true)
                Divider().frame(height: 40)
                ResultStat(value: DoseFormatter.formatMl(calc.volumeMl), label: "Volume")
            }
            HStack {
                ResultStat(value: DoseFormatter.formatConcentration(calc.concentrationMcgPerMl), label: "Concentration")
                Divider().frame(height: 40)
                ResultStat(value: "\(dosesPerVial)", label: "Doses per vial")
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.accentColor.opacity(0.12))
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

private struct ResultStat: View {
    let value: String
    let label: String
    var emphasis: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(emphasis ? .title2.weight(.bold) : .headline)
                .monospacedDigit()
                .foregroundStyle(emphasis ? Color.accentColor : .primary)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ReconstitutionView()
        .modelContainer(SampleData.makeInMemoryContainer())
}
