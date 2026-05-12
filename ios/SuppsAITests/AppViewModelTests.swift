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

    func testGoalRouteReopensOnboardingAtGoalStep() throws {
        let model = AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: true)

        model.open(try XCTUnwrap(URL(string: "suppsai://goal")))

        XCTAssertFalse(model.hasCompletedOnboarding)
        XCTAssertEqual(model.onboardingStep, .goal)
        XCTAssertEqual(model.onboardingRouteVersion, 1)
    }

    func testGoalRouteRefreshesOnboardingWhenAlreadyVisible() throws {
        let model = AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: false)
        model.onboardingStep = .commitment

        model.open(try XCTUnwrap(URL(string: "suppsai://goal")))

        XCTAssertFalse(model.hasCompletedOnboarding)
        XCTAssertEqual(model.onboardingStep, .goal)
        XCTAssertEqual(model.onboardingRouteVersion, 1)
    }

    func testGoalRouteAcceptsPathStyleURL() throws {
        let route = AppRoute(url: try XCTUnwrap(URL(string: "suppsai:///goal")))

        XCTAssertEqual(route, .goal)
    }

    func testTabRouteOpensMainAppAtTab() throws {
        let model = AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: false)

        model.open(try XCTUnwrap(URL(string: "suppsai://coach")))

        XCTAssertTrue(model.hasCompletedOnboarding)
        XCTAssertEqual(model.selectedTab, .coach)
    }

    func testInvalidRouteLeavesStateAlone() throws {
        let model = AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: true)

        model.open(try XCTUnwrap(URL(string: "suppsai://unknown")))

        XCTAssertTrue(model.hasCompletedOnboarding)
        XCTAssertEqual(model.selectedTab, .today)
        XCTAssertEqual(model.onboardingStep, .hero)
    }

    func testOnboardingViewModelSyncsStepAndCompletion() {
        let model = AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: false)
        let onboarding = OnboardingViewModel(appModel: model, initialStep: .goal)

        onboarding.next()
        XCTAssertEqual(model.onboardingStep, .commitment)

        onboarding.back()
        XCTAssertEqual(model.onboardingStep, .goal)

        onboarding.finish()
        XCTAssertTrue(model.hasCompletedOnboarding)
        XCTAssertEqual(model.onboardingStep, .hero)
    }

    func testCoachIgnoresBlankQuestionsAndTrimsInput() {
        let model = AppViewModel(seed: MockSuppsData.seed)
        let coach = CoachViewModel(appModel: model)
        let originalCount = model.messages.count

        coach.sendQuickQuestion("   \n")
        XCTAssertEqual(model.messages.count, originalCount)

        coach.sendQuickQuestion("  Is this dose right?  ")
        XCTAssertEqual(model.messages.count, originalCount + 2)
        XCTAssertEqual(model.messages[originalCount].text, "Is this dose right?")
    }

    func testLibraryFiltersByKindAndSummarySearch() {
        let library = LibraryViewModel(appModel: AppViewModel(seed: MockSuppsData.seed))

        library.select(.peptide)
        XCTAssertEqual(Set(library.compounds.map(\.kind)), [.peptide])

        library.query = "weight-loss"
        library.select(nil)
        XCTAssertEqual(library.compounds.map(\.name), ["Semaglutide"])
    }

    func testStackAndProgressActionsNavigateToUsefulTabs() {
        let model = AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: true)

        StackViewModel(appModel: model).openStackBuilder()
        XCTAssertEqual(model.selectedTab, .library)

        ProgressViewModel(appModel: model).startCheckIn()
        XCTAssertEqual(model.selectedTab, .coach)
    }
}
