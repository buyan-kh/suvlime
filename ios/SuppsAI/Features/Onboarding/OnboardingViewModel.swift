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

    init(appModel: AppViewModel, initialStep: OnboardingStep = .hero) {
        self.appModel = appModel
        self.step = initialStep.rawValue
    }

    var totalSteps: Int { 6 }

    func next() {
        if step < totalSteps - 1 {
            step += 1
            syncStep()
        } else {
            showingPaywall = true
        }
    }

    func back() {
        step = max(0, step - 1)
        syncStep()
    }

    func finish() {
        appModel.completeOnboarding()
    }

    private func syncStep() {
        appModel.onboardingStep = OnboardingStep(rawValue: step) ?? .hero
    }
}
