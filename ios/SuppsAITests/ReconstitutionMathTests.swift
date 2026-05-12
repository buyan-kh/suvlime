import XCTest
@testable import SuppsAI

final class ReconstitutionMathTests: XCTestCase {
    func testCalculatesU100SyringeUnits() {
        let result = ReconstitutionMath.calculate(doseMcg: 250, vialMg: 5, bacWaterMl: 2)

        XCTAssertEqual(result.concentrationMcgPerMl, 2_500, accuracy: 0.001)
        XCTAssertEqual(result.volumeMl, 0.1, accuracy: 0.001)
        XCTAssertEqual(result.syringeUnits, 10, accuracy: 0.001)
    }

    func testInvalidInputsReturnZeroes() {
        let result = ReconstitutionMath.calculate(doseMcg: 250, vialMg: 0, bacWaterMl: 2)

        XCTAssertEqual(result.concentrationMcgPerMl, 0)
        XCTAssertEqual(result.volumeMl, 0)
        XCTAssertEqual(result.syringeUnits, 0)
    }
}

