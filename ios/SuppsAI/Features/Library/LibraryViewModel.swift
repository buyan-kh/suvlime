import Foundation
import Observation

@Observable
final class LibraryViewModel {
    private var appModel: AppViewModel
    var query = ""

    init(appModel: AppViewModel) {
        self.appModel = appModel
    }

    var trending: [ResearchCompound] {
        appModel.compounds.filter { $0.tag != nil }
    }

    var compounds: [ResearchCompound] {
        guard !query.isEmpty else { return appModel.compounds }
        return appModel.compounds.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
}

