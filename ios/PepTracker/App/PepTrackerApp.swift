import SwiftUI
import SwiftData

@main
struct PepTrackerApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema([Peptide.self, DosingProtocol.self, DoseLog.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        if let onDisk = try? ModelContainer(for: schema, configurations: [config]) {
            container = onDisk
        } else {
            // Falling back to in-memory keeps the app usable if the on-disk
            // store is corrupt; the user can re-enter data and we won't crash on launch.
            let mem = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            guard let memContainer = try? ModelContainer(for: schema, configurations: [mem]) else {
                fatalError("Failed to initialize ModelContainer")
            }
            container = memContainer
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
