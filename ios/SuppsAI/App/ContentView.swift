import SwiftUI

struct ContentView: View {
    @Bindable var viewModel: AppViewModel

    var body: some View {
        Group {
            if viewModel.hasCompletedOnboarding {
                MainTabView(viewModel: viewModel)
            } else {
                OnboardingView(viewModel: OnboardingViewModel(appModel: viewModel))
            }
        }
        .tint(BoldPalette.lime)
    }
}

struct MainTabView: View {
    @Bindable var viewModel: AppViewModel

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            TodayView(viewModel: TodayViewModel(appModel: viewModel))
                .tabItem { Label("Today", systemImage: "house.fill") }
                .tag(AppTab.today)

            StackView(viewModel: StackViewModel(appModel: viewModel))
                .tabItem { Label("Stack", systemImage: "pills.fill") }
                .tag(AppTab.stack)

            CoachView(viewModel: CoachViewModel(appModel: viewModel))
                .tabItem { Label("Coach", systemImage: "sparkles") }
                .tag(AppTab.coach)

            LibraryView(viewModel: LibraryViewModel(appModel: viewModel))
                .tabItem { Label("Library", systemImage: "books.vertical.fill") }
                .tag(AppTab.library)

            ProgressView(viewModel: ProgressViewModel(appModel: viewModel))
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }
                .tag(AppTab.progress)
        }
        .background(BoldPalette.paper)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(viewModel: AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: false))
                .previewDisplayName("Onboarding")
            ContentView(viewModel: AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: true))
                .previewDisplayName("Main App")
        }
    }
}
