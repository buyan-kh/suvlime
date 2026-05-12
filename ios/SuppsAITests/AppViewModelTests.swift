import XCTest
@testable import SuppsAI

final class AppViewModelTests: XCTestCase {
    func testSeedLoadsInstantPreviewData() {
        let model = AppViewModel(seed: MockSuppsData.seed)

        XCTAssertEqual(model.firstName, "Alex")
        XCTAssertEqual(model.stack.count, 6)
        XCTAssertEqual(model.todayTasks.count, 5)
        XCTAssertEqual(model.compounds.count, 6)
        XCTAssertEqual(model.currentScore, 89)
    }

    func testTogglingTaskUpdatesProgress() throws {
        let model = AppViewModel(seed: MockSuppsData.seed)
        let task = try XCTUnwrap(model.todayTasks.first { !$0.isDone })

        XCTAssertEqual(model.completedTaskCount, 3)
        model.toggleTask(task)

        XCTAssertEqual(model.completedTaskCount, 4)
        XCTAssertFalse(try XCTUnwrap(model.todayTasks.first { $0.id == task.id }).isDue)
    }
}

