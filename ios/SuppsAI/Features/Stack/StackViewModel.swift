import Foundation
import Observation

@Observable
final class StackViewModel {
    private var appModel: AppViewModel
    var selectedKind: SupplementKind?

    init(appModel: AppViewModel) {
        self.appModel = appModel
    }

    var items: [SupplementItem] {
        guard let selectedKind else { return appModel.stack }
        return appModel.stack.filter { $0.kind == selectedKind }
    }

    var featured: SupplementItem {
        appModel.stack.first ?? MockSuppsData.seed.stack[0]
    }

    var reconstitution: ReconstitutionResult {
        guard let vial = featured.vialMg, let bac = featured.bacWaterMl, let dose = featured.targetDoseMcg else {
            return .init(concentrationMcgPerMl: 0, volumeMl: 0, syringeUnits: 0)
        }
        return ReconstitutionMath.calculate(doseMcg: dose, vialMg: vial, bacWaterMl: bac)
    }
}

