import Foundation

enum MockSuppsData {
    static let seed: SuppsSeed = {
        let bpc = SupplementItem(
            name: "BPC-157",
            kind: .peptide,
            dose: "250 mcg SQ",
            timing: "8:00 AM + 9:00 PM",
            dayLabel: "14/30",
            colorHex: "#CFFF50",
            icon: "syringe.fill",
            note: "Belly fat, rotate sides each time.",
            evidence: 4,
            vialMg: 5,
            bacWaterMl: 2,
            targetDoseMcg: 250
        )
        let sema = SupplementItem(
            name: "Semaglutide",
            kind: .glp1,
            dose: "0.5 mg",
            timing: "Monday morning",
            dayLabel: "week 6",
            colorHex: "#FF5A36",
            icon: "drop.fill",
            note: "Log appetite and nausea every week.",
            evidence: 5
        )
        let tb = SupplementItem(
            name: "TB-500",
            kind: .peptide,
            dose: "2 mg",
            timing: "Mon / Wed / Fri",
            dayLabel: "14/28",
            colorHex: "#7FB8FF",
            icon: "bolt.heart.fill",
            note: "Pairs well with BPC-157 for recovery.",
            evidence: 4
        )
        let nmn = SupplementItem(
            name: "NMN",
            kind: .longevity,
            dose: "500 mg",
            timing: "12:00 PM",
            dayLabel: "daily",
            colorHex: "#FFD86B",
            icon: "sparkles",
            note: "Energy check-in trends up this month.",
            evidence: 3
        )
        let creatine = SupplementItem(
            name: "Creatine",
            kind: .supplement,
            dose: "5 g",
            timing: "6:00 PM",
            dayLabel: "daily",
            colorHex: "#FFB8D9",
            icon: "dumbbell.fill",
            note: "Simple, cheap, strong evidence.",
            evidence: 5
        )
        let magnesium = SupplementItem(
            name: "Magnesium",
            kind: .supplement,
            dose: "400 mg",
            timing: "9:00 PM",
            dayLabel: "daily",
            colorHex: "#B8E0FF",
            icon: "moon.zzz.fill",
            note: "Sleep improves when taken before 9 PM.",
            evidence: 4
        )

        let stack = [bpc, sema, tb, nmn, creatine, magnesium]
        let tasks = [
            DoseTask(supplementID: bpc.id, name: bpc.name, dose: bpc.dose, time: "8:00 AM", isDone: true, isDue: false, colorHex: bpc.colorHex, icon: bpc.icon),
            DoseTask(supplementID: sema.id, name: sema.name, dose: sema.dose, time: "8:00 AM", isDone: true, isDue: false, colorHex: sema.colorHex, icon: sema.icon),
            DoseTask(supplementID: magnesium.id, name: magnesium.name, dose: magnesium.dose, time: "9:00 PM", isDone: true, isDue: false, colorHex: magnesium.colorHex, icon: magnesium.icon),
            DoseTask(supplementID: nmn.id, name: nmn.name, dose: nmn.dose, time: "12:00 PM", isDone: false, isDue: true, colorHex: nmn.colorHex, icon: nmn.icon),
            DoseTask(supplementID: creatine.id, name: creatine.name, dose: creatine.dose, time: "6:00 PM", isDone: false, isDue: false, colorHex: creatine.colorHex, icon: creatine.icon)
        ]

        return SuppsSeed(
            firstName: "Alex",
            streakDays: 14,
            scoreHistory: [62, 68, 71, 70, 75, 78, 82, 85, 89],
            stack: stack,
            todayTasks: tasks,
            compounds: [
                ResearchCompound(name: "Retatrutide", kind: .glp1, summary: "Triple agonist people are watching for fat loss.", evidence: 4, tag: "HOT", colorHex: "#FF5A36"),
                ResearchCompound(name: "Tesofensine", kind: .recovery, summary: "Brain and appetite pathway compound.", evidence: 3, tag: "NEW", colorHex: "#FFD86B"),
                ResearchCompound(name: "BPC-157", kind: .peptide, summary: "The body protection peptide. It helps you heal fast.", evidence: 4, tag: nil, colorHex: "#CFFF50"),
                ResearchCompound(name: "TB-500", kind: .peptide, summary: "Recovery peptide often paired with BPC-157.", evidence: 4, tag: nil, colorHex: "#7FB8FF"),
                ResearchCompound(name: "Semaglutide", kind: .glp1, summary: "GLP-1 with strong weight-loss data.", evidence: 5, tag: nil, colorHex: "#FF5A36"),
                ResearchCompound(name: "Creatine", kind: .supplement, summary: "Simple strength and cognition support.", evidence: 5, tag: nil, colorHex: "#FFB8D9")
            ],
            messages: [
                ChatMessage(text: "Hey Alex. I see you started BPC-157 14 days ago. How are your shoulders feeling?", isUser: false),
                ChatMessage(text: "Way better. But it tingles a bit at the injection site.", isUser: true),
                ChatMessage(text: "That can happen. Try pinching the skin a bit more before you poke. Rotate the spot too.", isUser: false),
                ChatMessage(text: "Should I add anything to speed it up?", isUser: true),
                ChatMessage(text: "TB-500 pairs well with BPC-157. Want me to add a 4-week cycle to your stack?", isUser: false, quickActions: ["Yes, add it", "Tell me more"])
            ],
            metrics: [
                ProgressMetric(label: "Weight", value: "83.2 kg", delta: "down 3.8 in 9w", colorHex: "#FF5A36"),
                ProgressMetric(label: "Energy", value: "8.4 /10", delta: "up 68%", colorHex: "#CFFF50"),
                ProgressMetric(label: "Sleep", value: "7h 42m", delta: "up 32 min", colorHex: "#7FB8FF"),
                ProgressMetric(label: "HRV", value: "64 ms", delta: "up 11", colorHex: "#FFD86B")
            ]
        )
    }()
}

