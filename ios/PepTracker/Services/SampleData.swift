import Foundation
import SwiftData

/// Seeds preview/in-memory containers with a small realistic dataset.
/// Production launches start empty.
enum SampleData {

    static func seed(into context: ModelContext) {
        let bpc = Peptide(
            name: "BPC-157",
            details: "Body Protection Compound. Studied for tissue repair.",
            vialSizeMg: 5,
            bacWaterMl: 2,
            defaultDoseMcg: 250,
            colorHex: "#4F97F2",
            symbolName: "leaf.fill",
            vialOpenedAt: Calendar.current.date(byAdding: .day, value: -6, to: .now)
        )

        let tb500 = Peptide(
            name: "TB-500",
            details: "Thymosin Beta-4 fragment.",
            vialSizeMg: 5,
            bacWaterMl: 2.5,
            defaultDoseMcg: 500,
            colorHex: "#A571F2",
            symbolName: "bolt.heart.fill",
            vialOpenedAt: Calendar.current.date(byAdding: .day, value: -2, to: .now)
        )

        context.insert(bpc)
        context.insert(tb500)

        let morning = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now) ?? .now
        let evening = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: .now) ?? .now

        let bpcAm = DosingProtocol(
            name: "BPC AM",
            peptide: bpc,
            doseMcg: 250,
            frequency: .daily,
            timeOfDay: morning,
            startDate: Calendar.current.date(byAdding: .day, value: -10, to: .now) ?? .now,
            route: .subcutaneous,
            defaultSite: .leftAbdomen
        )
        let bpcPm = DosingProtocol(
            name: "BPC PM",
            peptide: bpc,
            doseMcg: 250,
            frequency: .daily,
            timeOfDay: evening,
            startDate: Calendar.current.date(byAdding: .day, value: -10, to: .now) ?? .now,
            route: .subcutaneous,
            defaultSite: .rightAbdomen
        )
        let tbWeekly = DosingProtocol(
            name: "TB-500 loading",
            peptide: tb500,
            doseMcg: 5000,
            frequency: .mwf,
            timeOfDay: morning,
            startDate: Calendar.current.date(byAdding: .day, value: -10, to: .now) ?? .now,
            route: .subcutaneous,
            defaultSite: .leftThigh
        )

        context.insert(bpcAm)
        context.insert(bpcPm)
        context.insert(tbWeekly)

        // Backfill some history so charts/stats look populated.
        for offset in 1...8 {
            guard let day = Calendar.current.date(byAdding: .day, value: -offset, to: .now) else { continue }
            let log = DoseLog(
                peptide: bpc,
                protocolId: bpcAm.id,
                takenAt: day,
                doseMcg: 250,
                site: offset.isMultiple(of: 2) ? .leftAbdomen : .rightAbdomen,
                route: .subcutaneous
            )
            let calc = ReconstitutionCalculator.calculate(
                doseMcg: log.doseMcg,
                vialMg: bpc.vialSizeMg,
                bacWaterMl: bpc.bacWaterMl
            )
            log.volumeMl = calc.volumeMl
            log.syringeUnits = calc.syringeUnits
            context.insert(log)
        }
    }

    @MainActor
    static func makeInMemoryContainer(seeded: Bool = true) -> ModelContainer {
        let schema = Schema([Peptide.self, DosingProtocol.self, DoseLog.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        // swiftlint:disable:next force_try
        let container = try! ModelContainer(for: schema, configurations: [config])
        if seeded {
            seed(into: container.mainContext)
        }
        return container
    }
}
