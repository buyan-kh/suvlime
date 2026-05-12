import Foundation
import Observation

@Observable
final class LibraryViewModel {
    private var appModel: AppViewModel
    var query = ""
    var selectedKind: SupplementKind?

    init(appModel: AppViewModel) {
        self.appModel = appModel
    }

    var trending: [ResearchCompound] {
        appModel.compounds.filter { $0.tag != nil }
    }

    var compounds: [ResearchCompound] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        return appModel.compounds.filter { compound in
            let matchesKind = selectedKind == nil || compound.kind == selectedKind
            let matchesQuery = trimmedQuery.isEmpty
                || compound.name.localizedCaseInsensitiveContains(trimmedQuery)
                || compound.summary.localizedCaseInsensitiveContains(trimmedQuery)

            return matchesKind && matchesQuery
        }
    }

    func select(_ kind: SupplementKind?) {
        selectedKind = kind
    }
}
