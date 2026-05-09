import SwiftUI
import SwiftData

struct ProtocolEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let peptide: Peptide
    var existing: DosingProtocol?

    @State private var name: String = ""
    @State private var doseMcg: Double = 0
    @State private var doseText: String = ""
    @State private var frequency: DoseFrequency = .daily
    @State private var customWeekdays: Int = 0b0111_1111
    @State private var timeOfDay: Date = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now) ?? .now
    @State private var startDate: Date = .now
    @State private var hasEndDate = false
    @State private var endDate: Date = Calendar.current.date(byAdding: .month, value: 1, to: .now) ?? .now
    @State private var route: AdministrationRoute = .subcutaneous
    @State private var defaultSite: InjectionSite?
    @State private var isActive: Bool = true
    @State private var notificationsEnabled: Bool = true
    @State private var notes: String = ""

    @State private var showingNotificationsAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Protocol") {
                    TextField("Name (e.g. AM dose)", text: $name)
                        .textInputAutocapitalization(.words)
                    HStack {
                        TextField("Dose", text: $doseText)
                            .keyboardType(.decimalPad)
                            .onChange(of: doseText) { _, new in
                                if let v = Double(new.replacingOccurrences(of: ",", with: ".")) { doseMcg = v }
                            }
                        Text("mcg").foregroundStyle(.secondary)
                    }
                    LabeledContent("On syringe") {
                        Text(syringeSummary)
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }

                Section("Schedule") {
                    Picker("Frequency", selection: $frequency.animation()) {
                        ForEach(DoseFrequency.allCases) { f in
                            Text(f.displayName).tag(f)
                        }
                    }
                    if frequency == .custom {
                        WeekdaySelector(mask: $customWeekdays)
                    }
                    DatePicker("Time of day", selection: $timeOfDay, displayedComponents: [.hourAndMinute])
                    DatePicker("Start", selection: $startDate, displayedComponents: [.date])
                    Toggle("Set end date", isOn: $hasEndDate.animation())
                    if hasEndDate {
                        DatePicker("End", selection: $endDate, displayedComponents: [.date])
                    }
                }

                Section("Administration") {
                    Picker("Route", selection: $route) {
                        ForEach(AdministrationRoute.allCases) { r in
                            Text(r.displayName).tag(r)
                        }
                    }
                    Picker("Default site", selection: defaultSiteBinding) {
                        Text("None").tag(Optional<InjectionSite>(nil))
                        ForEach(InjectionSite.allCases) { s in
                            Text(s.displayName).tag(Optional(s))
                        }
                    }
                }

                Section {
                    Toggle("Active", isOn: $isActive)
                    Toggle("Reminders", isOn: $notificationsEnabled)
                } footer: {
                    Text("Reminders are scheduled for the next 30 days when active.")
                }

                Section("Notes") {
                    TextField("Optional", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }

                if existing != nil {
                    Section {
                        Button("Delete protocol", role: .destructive, action: delete)
                    }
                }
            }
            .navigationTitle(existing == nil ? "New Protocol" : "Edit Protocol")
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
            .alert("Enable notifications", isPresented: $showingNotificationsAlert) {
                Button("Open Settings") { openSettings() }
                Button("Not now", role: .cancel) { }
            } message: {
                Text("Notifications are disabled for PepTracker. Enable them in Settings to get dose reminders.")
            }
            .onAppear(perform: prefillIfEditing)
        }
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && doseMcg > 0
    }

    private var defaultSiteBinding: Binding<InjectionSite?> {
        Binding(get: { defaultSite }, set: { defaultSite = $0 })
    }

    private var syringeSummary: String {
        let r = ReconstitutionCalculator.calculate(
            doseMcg: doseMcg,
            vialMg: peptide.vialSizeMg,
            bacWaterMl: peptide.bacWaterMl
        )
        return "\(DoseFormatter.formatUnits(r.syringeUnits)) · \(DoseFormatter.formatMl(r.volumeMl))"
    }

    private func prefillIfEditing() {
        if let proto = existing {
            name = proto.name
            doseMcg = proto.doseMcg
            doseText = proto.doseMcg.cleanString
            frequency = proto.frequency
            customWeekdays = proto.customWeekdays
            timeOfDay = proto.timeOfDay
            startDate = proto.startDate
            hasEndDate = proto.endDate != nil
            endDate = proto.endDate ?? endDate
            route = proto.route
            defaultSite = proto.defaultSite
            isActive = proto.isActive
            notificationsEnabled = proto.notificationsEnabled
            notes = proto.notes
        } else {
            doseMcg = peptide.defaultDoseMcg
            doseText = peptide.defaultDoseMcg.cleanString
            route = peptide.route
            name = "\(peptide.name) dose"
        }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let proto: DosingProtocol
        if let existing {
            proto = existing
            proto.name = trimmed
            proto.doseMcg = doseMcg
            proto.frequency = frequency
            proto.customWeekdays = customWeekdays
            proto.timeOfDay = timeOfDay
            proto.startDate = startDate
            proto.endDate = hasEndDate ? endDate : nil
            proto.route = route
            proto.defaultSite = defaultSite
            proto.isActive = isActive
            proto.notificationsEnabled = notificationsEnabled
            proto.notes = notes
        } else {
            proto = DosingProtocol(
                name: trimmed,
                peptide: peptide,
                doseMcg: doseMcg,
                frequency: frequency,
                customWeekdays: customWeekdays,
                timeOfDay: timeOfDay,
                startDate: startDate,
                endDate: hasEndDate ? endDate : nil,
                route: route,
                defaultSite: defaultSite,
                notes: notes,
                isActive: isActive,
                notificationsEnabled: notificationsEnabled
            )
            modelContext.insert(proto)
        }

        try? modelContext.save()

        Task { @MainActor in
            if proto.notificationsEnabled && proto.isActive {
                let granted: Bool
                if NotificationManager.shared.authorizationStatus == .notDetermined {
                    granted = await NotificationManager.shared.requestAuthorization()
                } else {
                    granted = NotificationManager.shared.authorizationStatus == .authorized
                        || NotificationManager.shared.authorizationStatus == .provisional
                }
                if granted {
                    await NotificationManager.shared.reschedule(proto)
                } else {
                    showingNotificationsAlert = true
                }
            } else {
                NotificationManager.shared.cancel(proto)
            }
            dismiss()
        }
    }

    private func delete() {
        guard let existing else { return }
        NotificationManager.shared.cancel(existing)
        modelContext.delete(existing)
        try? modelContext.save()
        dismiss()
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

private struct WeekdaySelector: View {
    @Binding var mask: Int

    private let labels = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<7) { i in
                let bit = 1 << i
                let on = (mask & bit) != 0
                Button {
                    if on { mask &= ~bit } else { mask |= bit }
                } label: {
                    Text(labels[i])
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity, minHeight: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(on ? Color.accentColor : Color(.tertiarySystemFill))
                        )
                        .foregroundStyle(on ? .white : .primary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(labels[i]) \(on ? "selected" : "not selected")")
            }
        }
    }
}

#Preview {
    ProtocolEditorView(peptide: Peptide(name: "BPC-157"))
        .modelContainer(SampleData.makeInMemoryContainer())
}
