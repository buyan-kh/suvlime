import Foundation
import Observation

@Observable
final class TodayViewModel {
    private var appModel: AppViewModel

    init(appModel: AppViewModel) {
        self.appModel = appModel
    }

    var firstName: String { appModel.firstName }
    var streakDays: Int { appModel.streakDays }
    var tasks: [DoseTask] { appModel.todayTasks }
    var doneCount: Int { appModel.completedTaskCount }
    var progress: Double { appModel.todayProgress }

    var insight: String {
        "You sleep 32 min longer when you take magnesium before 9 PM. Worth setting an alarm?"
    }

    func toggle(_ task: DoseTask) {
        appModel.toggleTask(task)
    }
}

