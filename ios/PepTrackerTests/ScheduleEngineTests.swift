import XCTest
@testable import PepTracker

final class ScheduleEngineTests: XCTestCase {

    private func calendar(from iso: String) -> (Calendar, Date) {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return (cal, f.date(from: iso)!)
    }

    func testDailyAlwaysFiresOnOrAfterStart() {
        let (cal, day) = calendar(from: "2024-06-10T00:00:00Z")
        let proto = DosingProtocol(name: "x", doseMcg: 250, frequency: .daily, startDate: day)
        XCTAssertTrue(ScheduleEngine.isScheduled(proto, on: day, calendar: cal))
        XCTAssertTrue(ScheduleEngine.isScheduled(proto, on: cal.date(byAdding: .day, value: 1, to: day)!, calendar: cal))
        XCTAssertFalse(ScheduleEngine.isScheduled(proto, on: cal.date(byAdding: .day, value: -1, to: day)!, calendar: cal))
    }

    func testEveryOtherDay() {
        let (cal, start) = calendar(from: "2024-06-10T00:00:00Z")
        let proto = DosingProtocol(name: "x", doseMcg: 250, frequency: .everyOtherDay, startDate: start)
        XCTAssertTrue(ScheduleEngine.isScheduled(proto, on: start, calendar: cal))
        XCTAssertFalse(ScheduleEngine.isScheduled(proto, on: cal.date(byAdding: .day, value: 1, to: start)!, calendar: cal))
        XCTAssertTrue(ScheduleEngine.isScheduled(proto, on: cal.date(byAdding: .day, value: 2, to: start)!, calendar: cal))
    }

    func testMWFSchedule() {
        let (cal, _) = calendar(from: "2024-06-10T00:00:00Z")
        // 2024-06-10 is a Monday.
        let monday = cal.date(from: DateComponents(year: 2024, month: 6, day: 10))!
        let tuesday = cal.date(byAdding: .day, value: 1, to: monday)!
        let wednesday = cal.date(byAdding: .day, value: 2, to: monday)!
        let proto = DosingProtocol(name: "x", doseMcg: 250, frequency: .mwf, startDate: monday)
        XCTAssertTrue(ScheduleEngine.isScheduled(proto, on: monday, calendar: cal))
        XCTAssertFalse(ScheduleEngine.isScheduled(proto, on: tuesday, calendar: cal))
        XCTAssertTrue(ScheduleEngine.isScheduled(proto, on: wednesday, calendar: cal))
    }

    func testEndDateBlocksFiring() {
        let (cal, start) = calendar(from: "2024-06-10T00:00:00Z")
        let end = cal.date(byAdding: .day, value: 3, to: start)!
        let proto = DosingProtocol(name: "x", doseMcg: 250, frequency: .daily,
                                   startDate: start, endDate: end)
        XCTAssertTrue(ScheduleEngine.isScheduled(proto, on: end, calendar: cal))
        XCTAssertFalse(ScheduleEngine.isScheduled(proto, on: cal.date(byAdding: .day, value: 1, to: end)!, calendar: cal))
    }

    func testInactiveProtocolNeverFires() {
        let (cal, start) = calendar(from: "2024-06-10T00:00:00Z")
        let proto = DosingProtocol(name: "x", doseMcg: 250, frequency: .daily,
                                   startDate: start, isActive: false)
        XCTAssertFalse(ScheduleEngine.isScheduled(proto, on: start, calendar: cal))
    }
}
