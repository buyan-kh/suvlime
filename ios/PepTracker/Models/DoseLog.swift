import Foundation
import SwiftData

@Model
final class DoseLog {
    @Attribute(.unique) var id: UUID
    var peptide: Peptide?
    var protocolId: UUID?

    var takenAt: Date

    /// Recorded dose, in micrograms.
    var doseMcg: Double

    /// Volume drawn on syringe, in milliliters (computed at time of log).
    var volumeMl: Double

    /// Units on a 100u/ml insulin syringe (computed at time of log).
    var syringeUnits: Double

    var siteRaw: String?
    var routeRaw: String

    var notes: String
    var skipped: Bool

    init(
        id: UUID = UUID(),
        peptide: Peptide? = nil,
        protocolId: UUID? = nil,
        takenAt: Date = .now,
        doseMcg: Double,
        volumeMl: Double = 0,
        syringeUnits: Double = 0,
        site: InjectionSite? = nil,
        route: AdministrationRoute = .subcutaneous,
        notes: String = "",
        skipped: Bool = false
    ) {
        self.id = id
        self.peptide = peptide
        self.protocolId = protocolId
        self.takenAt = takenAt
        self.doseMcg = doseMcg
        self.volumeMl = volumeMl
        self.syringeUnits = syringeUnits
        self.siteRaw = site?.rawValue
        self.routeRaw = route.rawValue
        self.notes = notes
        self.skipped = skipped
    }

    var site: InjectionSite? {
        get { siteRaw.flatMap { InjectionSite(rawValue: $0) } }
        set { siteRaw = newValue?.rawValue }
    }

    var route: AdministrationRoute {
        get { AdministrationRoute(rawValue: routeRaw) ?? .subcutaneous }
        set { routeRaw = newValue.rawValue }
    }
}
