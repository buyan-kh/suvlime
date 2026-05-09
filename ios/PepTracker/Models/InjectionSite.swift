import Foundation

enum InjectionSite: String, Codable, CaseIterable, Identifiable {
    case leftAbdomen
    case rightAbdomen
    case leftThigh
    case rightThigh
    case leftDeltoid
    case rightDeltoid
    case leftGlute
    case rightGlute

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .leftAbdomen:   return "Left Abdomen"
        case .rightAbdomen:  return "Right Abdomen"
        case .leftThigh:     return "Left Thigh"
        case .rightThigh:    return "Right Thigh"
        case .leftDeltoid:   return "Left Deltoid"
        case .rightDeltoid:  return "Right Deltoid"
        case .leftGlute:     return "Left Glute"
        case .rightGlute:    return "Right Glute"
        }
    }

    var symbolName: String { "figure" }
}

enum AdministrationRoute: String, Codable, CaseIterable, Identifiable {
    case subcutaneous
    case intramuscular
    case oral
    case nasal
    case topical

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .subcutaneous:   return "Subcutaneous"
        case .intramuscular:  return "Intramuscular"
        case .oral:           return "Oral"
        case .nasal:          return "Nasal"
        case .topical:        return "Topical"
        }
    }

    var shortLabel: String {
        switch self {
        case .subcutaneous:   return "SubQ"
        case .intramuscular:  return "IM"
        case .oral:           return "Oral"
        case .nasal:          return "Nasal"
        case .topical:        return "Topical"
        }
    }
}
