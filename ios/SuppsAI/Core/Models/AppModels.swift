import Foundation
import SwiftUI

enum AppTab: Hashable {
    case today
    case stack
    case coach
    case library
    case progress
}

enum SupplementKind: String, CaseIterable, Identifiable {
    case peptide = "Peptide"
    case glp1 = "GLP-1"
    case supplement = "Supp"
    case longevity = "Longevity"
    case recovery = "Recovery"

    var id: String { rawValue }
}

struct SupplementItem: Identifiable, Hashable {
    let id: UUID
    var name: String
    var kind: SupplementKind
    var dose: String
    var timing: String
    var dayLabel: String
    var colorHex: String
    var icon: String
    var note: String
    var evidence: Int
    var vialMg: Double?
    var bacWaterMl: Double?
    var targetDoseMcg: Double?

    init(
        id: UUID = UUID(),
        name: String,
        kind: SupplementKind,
        dose: String,
        timing: String,
        dayLabel: String,
        colorHex: String,
        icon: String,
        note: String,
        evidence: Int,
        vialMg: Double? = nil,
        bacWaterMl: Double? = nil,
        targetDoseMcg: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.kind = kind
        self.dose = dose
        self.timing = timing
        self.dayLabel = dayLabel
        self.colorHex = colorHex
        self.icon = icon
        self.note = note
        self.evidence = evidence
        self.vialMg = vialMg
        self.bacWaterMl = bacWaterMl
        self.targetDoseMcg = targetDoseMcg
    }
}

struct DoseTask: Identifiable, Hashable {
    let id: UUID
    var supplementID: UUID
    var name: String
    var dose: String
    var time: String
    var isDone: Bool
    var isDue: Bool
    var colorHex: String
    var icon: String

    init(
        id: UUID = UUID(),
        supplementID: UUID,
        name: String,
        dose: String,
        time: String,
        isDone: Bool,
        isDue: Bool,
        colorHex: String,
        icon: String
    ) {
        self.id = id
        self.supplementID = supplementID
        self.name = name
        self.dose = dose
        self.time = time
        self.isDone = isDone
        self.isDue = isDue
        self.colorHex = colorHex
        self.icon = icon
    }
}

struct ResearchCompound: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var kind: SupplementKind
    var summary: String
    var evidence: Int
    var tag: String?
    var colorHex: String
}

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    var text: String
    var isUser: Bool
    var quickActions: [String] = []
}

struct ProgressMetric: Identifiable, Hashable {
    let id = UUID()
    var label: String
    var value: String
    var delta: String
    var colorHex: String
}

struct SuppsSeed {
    var firstName: String
    var streakDays: Int
    var scoreHistory: [Int]
    var stack: [SupplementItem]
    var todayTasks: [DoseTask]
    var compounds: [ResearchCompound]
    var messages: [ChatMessage]
    var metrics: [ProgressMetric]
}

