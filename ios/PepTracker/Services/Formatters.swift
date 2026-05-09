import Foundation

/// Centralized number/date formatters. Keeping a single source of truth
/// avoids inconsistent rounding across views.
enum DoseFormatter {

    /// Formats a dose in micrograms, automatically switching to milligrams
    /// when the value is at or above 1000 mcg.
    static func formatMcg(_ mcg: Double) -> String {
        if mcg >= 1000 {
            let mg = mcg / 1000
            return "\(trim(mg, fractionDigits: mg < 10 ? 2 : 1)) mg"
        }
        return "\(trim(mcg, fractionDigits: mcg < 10 ? 2 : 0)) mcg"
    }

    /// Formats a volume in milliliters with up to 3 decimals.
    static func formatMl(_ ml: Double) -> String {
        "\(trim(ml, fractionDigits: 3)) mL"
    }

    /// Formats syringe units to one decimal (insulin syringes are typically
    /// graduated in 1 or 2 unit increments, but a half unit is common).
    static func formatUnits(_ units: Double) -> String {
        "\(trim(units, fractionDigits: 1)) u"
    }

    /// Formats a concentration in mcg/mL, switching to mg/mL when large.
    static func formatConcentration(_ mcgPerMl: Double) -> String {
        if mcgPerMl >= 1000 {
            return "\(trim(mcgPerMl / 1000, fractionDigits: 2)) mg/mL"
        }
        return "\(trim(mcgPerMl, fractionDigits: 0)) mcg/mL"
    }

    private static func trim(_ value: Double, fractionDigits: Int) -> String {
        let f = NumberFormatter()
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = fractionDigits
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: value)) ?? String(value)
    }
}

enum DateDisplay {
    static let timeOfDay: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .none
        return f
    }()

    static let mediumDate: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    static let shortDateTime: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }()

    static let weekdayShort: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f
    }()
}
