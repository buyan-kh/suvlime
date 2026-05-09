import SwiftUI
import SwiftData
import UIKit

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var notifications = NotificationManager.shared

    @AppStorage("preferredUnit") private var preferredUnit: String = "auto"
    @AppStorage("warnExpiryDays") private var warnExpiryDays: Int = 5
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = true

    @State private var showingResetConfirm = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Notifications") {
                    HStack {
                        Image(systemName: notifications.authorizationStatus == .authorized ? "bell.fill" : "bell.slash")
                        Text(notificationStatusLabel)
                        Spacer()
                        if notifications.authorizationStatus != .authorized {
                            Button("Enable") {
                                Task {
                                    let granted = await notifications.requestAuthorization()
                                    if !granted { openSettings() }
                                }
                            }
                            .fontWeight(.semibold)
                        }
                    }
                }

                Section("Display") {
                    Picker("Dose units", selection: $preferredUnit) {
                        Text("Auto (mcg/mg)").tag("auto")
                        Text("Always mcg").tag("mcg")
                        Text("Always mg").tag("mg")
                    }
                    Stepper("Warn \(warnExpiryDays) days before vial expiry", value: $warnExpiryDays, in: 0...14)
                }

                Section("Data") {
                    Button(role: .destructive) {
                        showingResetConfirm = true
                    } label: {
                        Label("Erase all data", systemImage: "trash")
                    }
                }

                Section("About") {
                    LabeledContent("Version", value: Bundle.main.appVersion)
                    Link(destination: URL(string: "https://www.apple.com/legal/privacy/")!) {
                        Label("Privacy", systemImage: "lock")
                    }
                }

                Section {
                    Text("PepTracker is for personal record keeping. It does not provide medical advice. Consult a qualified healthcare provider before starting or changing any treatment.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog(
                "Erase all data?",
                isPresented: $showingResetConfirm,
                titleVisibility: .visible
            ) {
                Button("Erase everything", role: .destructive, action: eraseAll)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This deletes every peptide, protocol, and dose log on this device. This cannot be undone.")
            }
            .task {
                await notifications.refreshAuthorizationStatus()
            }
        }
    }

    private var notificationStatusLabel: String {
        switch notifications.authorizationStatus {
        case .authorized:   return "Reminders enabled"
        case .provisional:  return "Quiet reminders enabled"
        case .denied:       return "Reminders disabled in Settings"
        case .notDetermined: return "Reminders not set up"
        case .ephemeral:    return "Ephemeral session"
        @unknown default:   return "Unknown"
        }
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    private func eraseAll() {
        NotificationManager.shared.cancelAll()
        try? context.delete(model: DoseLog.self)
        try? context.delete(model: DosingProtocol.self)
        try? context.delete(model: Peptide.self)
        try? context.save()
    }
}

private extension Bundle {
    var appVersion: String {
        let v = infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(v) (\(b))"
    }
}

#Preview {
    SettingsView()
        .modelContainer(SampleData.makeInMemoryContainer())
}
