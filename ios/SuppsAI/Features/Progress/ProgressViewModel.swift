import Foundation
import Observation

@Observable
final class ProgressViewModel {
    private var appModel: AppViewModel

    init(appModel: AppViewModel) {
        self.appModel = appModel
    }

    var history: [Int] { appModel.scoreHistory }
    var score: Int { appModel.currentScore }
    var metrics: [ProgressMetric] { appModel.metrics }
    var recap: String { "Your energy jumped +18% since you added NMN. Keep going." }
}

