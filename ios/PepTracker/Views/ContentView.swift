import SwiftUI

struct ContentView: View {
    enum Tab: Hashable { case today, library, calculator, stats, settings }

    @State private var selection: Tab = .today

    var body: some View {
        TabView(selection: $selection) {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max.fill") }
                .tag(Tab.today)

            LibraryView()
                .tabItem { Label("Library", systemImage: "list.bullet.rectangle.fill") }
                .tag(Tab.library)

            ReconstitutionView()
                .tabItem { Label("Calculator", systemImage: "function") }
                .tag(Tab.calculator)

            StatsView()
                .tabItem { Label("Stats", systemImage: "chart.bar.fill") }
                .tag(Tab.stats)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                .tag(Tab.settings)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.makeInMemoryContainer())
}
