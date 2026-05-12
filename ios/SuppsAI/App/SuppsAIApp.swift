import SwiftUI

@main
struct SuppsAIApp: App {
    @State private var appModel = AppViewModel(seed: MockSuppsData.seed)

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: appModel)
        }
    }
}

