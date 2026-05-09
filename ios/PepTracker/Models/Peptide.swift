import Foundation
import SwiftData

@Model
final class Peptide {
    @Attribute(.unique) var id: UUID
    var name: String
    var details: String

    /// Total mass of peptide in the vial, in milligrams.
    var vialSizeMg: Double

    /// Volume of bacteriostatic water used to reconstitute the vial, in milliliters.
    var bacWaterMl: Double

    /// Default per-dose amount, stored in micrograms for precision.
    var defaultDoseMcg: Double

    /// Default route of administration.
    var routeRaw: String

    /// Hex color tag (e.g. "#4F97F2") used for visual identification.
    var colorHex: String

    /// SF Symbol used as the peptide's icon.
    var symbolName: String

    /// Date the current vial was opened. Used to estimate freshness.
    var vialOpenedAt: Date?

    /// Manufacturer-stated stability after reconstitution, in days.
    var stabilityDays: Int

    var createdAt: Date
    var archived: Bool

    @Relationship(deleteRule: .cascade, inverse: \DosingProtocol.peptide)
    var protocols: [DosingProtocol] = []

    @Relationship(deleteRule: .cascade, inverse: \DoseLog.peptide)
    var doses: [DoseLog] = []

    init(
        id: UUID = UUID(),
        name: String,
        details: String = "",
        vialSizeMg: Double = 5.0,
        bacWaterMl: Double = 2.0,
        defaultDoseMcg: Double = 250,
        route: AdministrationRoute = .subcutaneous,
        colorHex: String = "#4F97F2",
        symbolName: String = "syringe.fill",
        vialOpenedAt: Date? = nil,
        stabilityDays: Int = 30,
        createdAt: Date = .now,
        archived: Bool = false
    ) {
        self.id = id
        self.name = name
        self.details = details
        self.vialSizeMg = vialSizeMg
        self.bacWaterMl = bacWaterMl
        self.defaultDoseMcg = defaultDoseMcg
        self.routeRaw = route.rawValue
        self.colorHex = colorHex
        self.symbolName = symbolName
        self.vialOpenedAt = vialOpenedAt
        self.stabilityDays = stabilityDays
        self.createdAt = createdAt
        self.archived = archived
    }

    var route: AdministrationRoute {
        get { AdministrationRoute(rawValue: routeRaw) ?? .subcutaneous }
        set { routeRaw = newValue.rawValue }
    }

    /// Concentration of the reconstituted vial in micrograms per milliliter.
    var concentrationMcgPerMl: Double {
        guard bacWaterMl > 0 else { return 0 }
        return (vialSizeMg * 1000.0) / bacWaterMl
    }

    /// Estimated days until the reconstituted vial expires (nil if not opened).
    var daysUntilExpiry: Int? {
        guard let opened = vialOpenedAt else { return nil }
        let expiry = Calendar.current.date(byAdding: .day, value: stabilityDays, to: opened) ?? opened
        let comps = Calendar.current.dateComponents([.day], from: .now, to: expiry)
        return comps.day
    }
}
