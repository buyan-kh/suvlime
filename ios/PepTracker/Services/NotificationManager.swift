import Foundation
import UserNotifications

@MainActor
final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined

    private let center = UNUserNotificationCenter.current()
    private let identifierPrefix = "peptracker.protocol."

    private init() {
        Task { await refreshAuthorizationStatus() }
    }

    func refreshAuthorizationStatus() async {
        let settings = await center.notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }

    @discardableResult
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            await refreshAuthorizationStatus()
            return granted
        } catch {
            return false
        }
    }

    /// Replaces all pending notifications for a protocol with a fresh schedule
    /// covering the next `lookaheadDays` days.
    func reschedule(_ proto: DosingProtocol, lookaheadDays: Int = 30) async {
        cancel(proto)
        guard proto.notificationsEnabled, proto.isActive else { return }

        let cutoff = Calendar.current.date(byAdding: .day, value: lookaheadDays, to: .now) ?? .now
        let upcoming = ScheduleEngine.upcomingFireDates(for: proto, from: .now, limit: 64)
            .filter { $0 <= cutoff }

        for fire in upcoming {
            let content = UNMutableNotificationContent()
            content.title = proto.peptide?.name ?? proto.name
            let dose = DoseFormatter.formatMcg(proto.doseMcg)
            content.body = "Time for your \(dose) dose."
            content.sound = .default
            content.threadIdentifier = identifierPrefix + proto.id.uuidString

            let comps = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: fire
            )
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            let id = "\(identifierPrefix)\(proto.id.uuidString).\(Int(fire.timeIntervalSince1970))"
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

            try? await center.add(request)
        }
    }

    func cancel(_ proto: DosingProtocol) {
        let prefix = identifierPrefix + proto.id.uuidString
        center.getPendingNotificationRequests { requests in
            let ids = requests.map(\.identifier).filter { $0.hasPrefix(prefix) }
            self.center.removePendingNotificationRequests(withIdentifiers: ids)
        }
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }
}
