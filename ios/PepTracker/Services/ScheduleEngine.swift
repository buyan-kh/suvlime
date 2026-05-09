import Foundation

/// Computes whether a protocol is active on a given calendar day, and the
/// scheduled administration time on that day.
enum ScheduleEngine {

    /// Returns true if `date` falls on a day this protocol should fire.
    static func isScheduled(_ proto: DosingProtocol, on date: Date, calendar: Calendar = .current) -> Bool {
        guard proto.isActive else { return false }

        let day = calendar.startOfDay(for: date)
        let start = calendar.startOfDay(for: proto.startDate)
        guard day >= start else { return false }

        if let end = proto.endDate, day > calendar.startOfDay(for: end) {
            return false
        }

        switch proto.frequency {
        case .daily:
            return true

        case .everyOtherDay:
            let diff = calendar.dateComponents([.day], from: start, to: day).day ?? 0
            return diff % 2 == 0

        case .mwf:
            let weekday = calendar.component(.weekday, from: day)  // 1=Sun ... 7=Sat
            return weekday == 2 || weekday == 4 || weekday == 6

        case .tts:
            let weekday = calendar.component(.weekday, from: day)
            return weekday == 3 || weekday == 5 || weekday == 7

        case .weekly:
            let startWeekday = calendar.component(.weekday, from: start)
            let weekday = calendar.component(.weekday, from: day)
            return weekday == startWeekday

        case .custom:
            let weekday = calendar.component(.weekday, from: day)  // 1...7
            let bit = 1 << (weekday - 1)
            return (proto.customWeekdays & bit) != 0
        }
    }

    /// Returns the absolute datetime the protocol fires on `date` (combining the
    /// protocol's `timeOfDay` hour/minute with `date`'s calendar day).
    static func scheduledDateTime(_ proto: DosingProtocol, on date: Date, calendar: Calendar = .current) -> Date? {
        guard isScheduled(proto, on: date, calendar: calendar) else { return nil }
        let comps = calendar.dateComponents([.hour, .minute], from: proto.timeOfDay)
        return calendar.date(
            bySettingHour: comps.hour ?? 8,
            minute: comps.minute ?? 0,
            second: 0,
            of: date
        )
    }

    /// Returns the next N upcoming scheduled fire dates starting at `from`.
    static func upcomingFireDates(
        for proto: DosingProtocol,
        from: Date = .now,
        limit: Int = 14,
        calendar: Calendar = .current
    ) -> [Date] {
        var results: [Date] = []
        var cursor = calendar.startOfDay(for: from)
        var safety = 0
        while results.count < limit && safety < 365 {
            if let fire = scheduledDateTime(proto, on: cursor, calendar: calendar), fire >= from {
                results.append(fire)
            }
            guard let next = calendar.date(byAdding: .day, value: 1, to: cursor) else { break }
            cursor = next
            safety += 1
        }
        return results
    }
}
