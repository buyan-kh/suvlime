import Foundation

/// Pure-function dosing math. All inputs are explicit so the calculator is fully testable.
///
/// Reconstitution model:
/// 1. A vial contains `vialMg` of peptide.
/// 2. The user reconstitutes with `bacWaterMl` of bacteriostatic water.
/// 3. Concentration = (vialMg × 1000) / bacWaterMl  (in mcg/ml).
/// 4. A standard U-100 insulin syringe has 100 units per 1 ml,
///    so 1 unit = 0.01 ml = concentration / 100 mcg.
enum ReconstitutionCalculator {

    static let unitsPerMl: Double = 100  // U-100 insulin syringe

    struct Result: Equatable {
        let volumeMl: Double
        let syringeUnits: Double
        let concentrationMcgPerMl: Double
    }

    /// Calculates the volume and syringe units required for a given dose.
    /// Returns zeros if any input is non-positive (avoids divide-by-zero in the UI).
    static func calculate(
        doseMcg: Double,
        vialMg: Double,
        bacWaterMl: Double
    ) -> Result {
        guard doseMcg > 0, vialMg > 0, bacWaterMl > 0 else {
            return Result(volumeMl: 0, syringeUnits: 0, concentrationMcgPerMl: 0)
        }

        let concentration = (vialMg * 1000.0) / bacWaterMl  // mcg/ml
        let volumeMl = doseMcg / concentration               // ml
        let units = volumeMl * unitsPerMl                    // U-100 units

        return Result(
            volumeMl: volumeMl,
            syringeUnits: units,
            concentrationMcgPerMl: concentration
        )
    }

    /// Estimated number of doses remaining in a single vial at the given dose.
    static func dosesPerVial(doseMcg: Double, vialMg: Double) -> Int {
        guard doseMcg > 0, vialMg > 0 else { return 0 }
        return Int((vialMg * 1000.0) / doseMcg)
    }
}
