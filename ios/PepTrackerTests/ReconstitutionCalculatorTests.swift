import XCTest
@testable import PepTracker

final class ReconstitutionCalculatorTests: XCTestCase {

    func testTextbookBPC157() {
        // 5mg vial, 2mL BAC water, 250mcg dose → 10 units on a U-100 syringe.
        let r = ReconstitutionCalculator.calculate(doseMcg: 250, vialMg: 5, bacWaterMl: 2)
        XCTAssertEqual(r.concentrationMcgPerMl, 2500, accuracy: 0.0001)
        XCTAssertEqual(r.volumeMl, 0.1, accuracy: 0.0001)
        XCTAssertEqual(r.syringeUnits, 10, accuracy: 0.0001)
    }

    func testHigherDilution() {
        // 10mg vial, 5mL BAC water → 2000 mcg/mL. 500 mcg dose = 0.25 mL = 25 units.
        let r = ReconstitutionCalculator.calculate(doseMcg: 500, vialMg: 10, bacWaterMl: 5)
        XCTAssertEqual(r.concentrationMcgPerMl, 2000, accuracy: 0.0001)
        XCTAssertEqual(r.volumeMl, 0.25, accuracy: 0.0001)
        XCTAssertEqual(r.syringeUnits, 25, accuracy: 0.0001)
    }

    func testZeroInputsReturnZero() {
        XCTAssertEqual(ReconstitutionCalculator.calculate(doseMcg: 0, vialMg: 5, bacWaterMl: 2),
                       .init(volumeMl: 0, syringeUnits: 0, concentrationMcgPerMl: 0))
        XCTAssertEqual(ReconstitutionCalculator.calculate(doseMcg: 250, vialMg: 0, bacWaterMl: 2),
                       .init(volumeMl: 0, syringeUnits: 0, concentrationMcgPerMl: 0))
        XCTAssertEqual(ReconstitutionCalculator.calculate(doseMcg: 250, vialMg: 5, bacWaterMl: 0),
                       .init(volumeMl: 0, syringeUnits: 0, concentrationMcgPerMl: 0))
    }

    func testDosesPerVial() {
        XCTAssertEqual(ReconstitutionCalculator.dosesPerVial(doseMcg: 250, vialMg: 5), 20)
        XCTAssertEqual(ReconstitutionCalculator.dosesPerVial(doseMcg: 500, vialMg: 5), 10)
        XCTAssertEqual(ReconstitutionCalculator.dosesPerVial(doseMcg: 0, vialMg: 5), 0)
    }
}
