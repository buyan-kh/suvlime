import Foundation
import Observation

@Observable
final class OnboardingViewModel {
    private var appModel: AppViewModel
    var step = 0
    var selectedTaking: Set<String> = ["Peptides", "Pills", "Brain stuff"]
    var selectedGoals: Set<String> = ["Burn fat", "Live longer"]
    var seriousness = 9.0
    var showingPaywall = false

    init(appModel: AppViewModel) {
        self.appModel = appModel
    }

    var totalSteps: Int { 6 }

    func next() {
        if step < totalSteps - 1 {
            step += 1
        } else {
            showingPaywall = true
        }
    }

    func back() {
        step = max(0, step - 1)
    }

    func finish() {
        appModel.completeOnboarding()
    }
}

