import Foundation

struct ReconstitutionResult: Equatable {
    var concentrationMcgPerMl: Double
    var volumeMl: Double
    var syringeUnits: Double
}

enum ReconstitutionMath {
    static func calculate(doseMcg: Double, vialMg: Double, bacWaterMl: Double) -> ReconstitutionResult {
        guard doseMcg > 0, vialMg > 0, bacWaterMl > 0 else {
            return ReconstitutionResult(concentrationMcgPerMl: 0, volumeMl: 0, syringeUnits: 0)
        }

        let concentration = (vialMg * 1_000) / bacWaterMl
        let volume = doseMcg / concentration
        return ReconstitutionResult(
            concentrationMcgPerMl: concentration,
            volumeMl: volume,
            syringeUnits: volume * 100
        )
    }
}

