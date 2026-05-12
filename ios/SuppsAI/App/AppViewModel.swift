import Foundation
import Observation

@Observable
final class AppViewModel {
    var firstName: String
    var streakDays: Int
    var scoreHistory: [Int]
    var stack: [SupplementItem]
    var todayTasks: [DoseTask]
    var compounds: [ResearchCompound]
    var messages: [ChatMessage]
    var metrics: [ProgressMetric]
    var hasCompletedOnboarding: Bool
    var selectedTab: AppTab = .today

    init(seed: SuppsSeed, hasCompletedOnboarding: Bool = false) {
        self.firstName = seed.firstName
        self.streakDays = seed.streakDays
        self.scoreHistory = seed.scoreHistory
        self.stack = seed.stack
        self.todayTasks = seed.todayTasks
        self.compounds = seed.compounds
        self.messages = seed.messages
        self.metrics = seed.metrics
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }

    var completedTaskCount: Int {
        todayTasks.filter(\.isDone).count
    }

    var todayProgress: Double {
        guard !todayTasks.isEmpty else { return 0 }
        return Double(completedTaskCount) / Double(todayTasks.count)
    }

    var currentScore: Int {
        scoreHistory.last ?? 0
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
    }

    func showPaywall() {
        selectedTab = .today
    }

    func toggleTask(_ task: DoseTask) {
        guard let index = todayTasks.firstIndex(where: { $0.id == task.id }) else { return }
        todayTasks[index].isDone.toggle()
        todayTasks[index].isDue = false
    }
}

