import Foundation
import SwiftData

enum DoseFrequency: String, Codable, CaseIterable, Identifiable {
    case daily
    case everyOtherDay
    case mwf       // Mon/Wed/Fri
    case tts       // Tue/Thu/Sat
    case weekly
    case custom    // Uses customWeekdays bitmask (1=Sun, ... , 7=Sat)

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .daily:          return "Every day"
        case .everyOtherDay:  return "Every other day"
        case .mwf:            return "Mon · Wed · Fri"
        case .tts:            return "Tue · Thu · Sat"
        case .weekly:         return "Once a week"
        case .custom:         return "Custom days"
        }
    }
}

@Model
final class DosingProtocol {
    @Attribute(.unique) var id: UUID
    var name: String

    var peptide: Peptide?

    /// Dose per administration, in micrograms.
    var doseMcg: Double

    var frequencyRaw: String

    /// Bitmask of weekdays for `.custom` (bit 0 = Sun ... bit 6 = Sat).
    var customWeekdays: Int

    /// The hour and minute of day to administer (date portion ignored).
    var timeOfDay: Date

    var startDate: Date
    var endDate: Date?

    var routeRaw: String
    var defaultSiteRaw: String?

    var notes: String
    var isActive: Bool
    var notificationsEnabled: Bool

    init(
        id: UUID = UUID(),
        name: String,
        peptide: Peptide? = nil,
        doseMcg: Double,
        frequency: DoseFrequency = .daily,
        customWeekdays: Int = 0b0111_1111,
        timeOfDay: Date = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now) ?? .now,
        startDate: Date = .now,
        endDate: Date? = nil,
        route: AdministrationRoute = .subcutaneous,
        defaultSite: InjectionSite? = nil,
        notes: String = "",
        isActive: Bool = true,
        notificationsEnabled: Bool = true
    ) {
        self.id = id
        self.name = name
        self.peptide = peptide
        self.doseMcg = doseMcg
        self.frequencyRaw = frequency.rawValue
        self.customWeekdays = customWeekdays
        self.timeOfDay = timeOfDay
        self.startDate = startDate
        self.endDate = endDate
        self.routeRaw = route.rawValue
        self.defaultSiteRaw = defaultSite?.rawValue
        self.notes = notes
        self.isActive = isActive
        self.notificationsEnabled = notificationsEnabled
    }

    var frequency: DoseFrequency {
        get { DoseFrequency(rawValue: frequencyRaw) ?? .daily }
        set { frequencyRaw = newValue.rawValue }
    }

    var route: AdministrationRoute {
        get { AdministrationRoute(rawValue: routeRaw) ?? .subcutaneous }
        set { routeRaw = newValue.rawValue }
    }

    var defaultSite: InjectionSite? {
        get { defaultSiteRaw.flatMap { InjectionSite(rawValue: $0) } }
        set { defaultSiteRaw = newValue?.rawValue }
    }
}
