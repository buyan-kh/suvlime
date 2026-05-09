import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \DosingProtocol.timeOfDay) private var protocols: [DosingProtocol]
    @Query(sort: \DoseLog.takenAt, order: .reverse) private var allLogs: [DoseLog]

    @State private var presentingLog: DoseLogContext?
    @State private var presentingFreeformLog = false

    private var todayItems: [DueItem] {
        let cal = Calendar.current
        let today = Date.now
        return protocols
            .filter { ScheduleEngine.isScheduled($0, on: today, calendar: cal) }
            .compactMap { proto -> DueItem? in
                guard let when = ScheduleEngine.scheduledDateTime(proto, on: today, calendar: cal) else { return nil }
                let log = allLogs.first { log in
                    log.protocolId == proto.id && cal.isDate(log.takenAt, inSameDayAs: today)
                }
                return DueItem(protocol: proto, scheduledAt: when, log: log)
            }
            .sorted { $0.scheduledAt < $1.scheduledAt }
    }

    private var todaysLogs: [DoseLog] {
        let cal = Calendar.current
        return allLogs.filter { cal.isDate($0.takenAt, inSameDayAs: .now) }
    }

    private var completedToday: Int {
        todayItems.filter { $0.log != nil && $0.log?.skipped == false }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerCard
                    if todayItems.isEmpty {
                        emptyToday
                    } else {
                        scheduleSection
                    }
                    if !todaysLogs.isEmpty {
                        recentSection
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentingFreeformLog = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                    .accessibilityLabel("Log a dose")
                }
            }
            .sheet(item: $presentingLog) { ctx in
                LogDoseSheet(context: ctx)
            }
            .sheet(isPresented: $presentingFreeformLog) {
                LogDoseSheet(context: .freeform)
            }
        }
    }

    // MARK: – Sections

    private var headerCard: some View {
        let total = todayItems.count
        let done = completedToday
        let progress = total == 0 ? 0 : Double(done) / Double(total)

        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Date.now, format: .dateTime.weekday(.wide).month(.wide).day())
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    Text(headlineText)
                        .font(.title2.weight(.bold))
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color(.tertiarySystemFill), lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.4), value: progress)
                    VStack(spacing: 0) {
                        Text("\(done)")
                            .font(.headline.weight(.bold))
                        Text("of \(total)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 56, height: 56)
                .accessibilityLabel("\(done) of \(total) doses logged today")
            }
        }
        .card()
    }

    private var headlineText: String {
        let due = todayItems.count
        if due == 0 { return "No doses scheduled" }
        if completedToday == due { return "All done — nice work" }
        let remaining = due - completedToday
        return remaining == 1 ? "1 dose left" : "\(remaining) doses left"
    }

    private var emptyToday: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 36))
                .foregroundStyle(Color.accentColor.opacity(0.7))
            Text("Nothing scheduled today")
                .font(.headline)
            Text("Use Library to add a peptide and a dosing protocol.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .card()
    }

    private var scheduleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Schedule")
            VStack(spacing: 10) {
                ForEach(todayItems) { item in
                    TodayRow(
                        item: item,
                        onLog: { presentingLog = .from(item) },
                        onSkip: { skip(item) }
                    )
                }
            }
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Logged today")
            VStack(spacing: 10) {
                ForEach(todaysLogs) { log in
                    LoggedRow(log: log)
                }
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 4)
    }

    // MARK: – Actions

    private func skip(_ item: DueItem) {
        let log = DoseLog(
            peptide: item.protocol.peptide,
            protocolId: item.protocol.id,
            takenAt: .now,
            doseMcg: item.protocol.doseMcg,
            site: item.protocol.defaultSite,
            route: item.protocol.route,
            skipped: true
        )
        context.insert(log)
        try? context.save()
    }
}

// MARK: – Models

struct DueItem: Identifiable {
    var id: UUID { `protocol`.id }
    let `protocol`: DosingProtocol
    let scheduledAt: Date
    let log: DoseLog?
}

enum DoseLogContext: Identifiable {
    case fromProtocol(DosingProtocol, scheduledAt: Date)
    case freeform

    var id: String {
        switch self {
        case .fromProtocol(let p, _): return "proto-\(p.id.uuidString)"
        case .freeform:               return "freeform"
        }
    }

    static func from(_ item: DueItem) -> DoseLogContext {
        .fromProtocol(item.`protocol`, scheduledAt: item.scheduledAt)
    }
}

// MARK: – Rows

private struct TodayRow: View {
    let item: DueItem
    let onLog: () -> Void
    let onSkip: () -> Void

    private var status: Status {
        guard let log = item.log else { return .pending }
        return log.skipped ? .skipped : .done
    }

    enum Status { case pending, done, skipped }

    var body: some View {
        HStack(spacing: 12) {
            PeptideBadge(
                symbolName: item.protocol.peptide?.symbolName ?? "syringe.fill",
                colorHex: item.protocol.peptide?.colorHex ?? "#4F97F2"
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(item.protocol.peptide?.name ?? item.protocol.name)
                    .font(.headline)
                HStack(spacing: 6) {
                    Text(DoseFormatter.formatMcg(item.protocol.doseMcg))
                    Text("·")
                    Text(DateDisplay.timeOfDay.string(from: item.scheduledAt))
                    if let site = item.protocol.defaultSite {
                        Text("·")
                        Text(site.displayName).lineLimit(1)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            switch status {
            case .pending:
                Menu {
                    Button("Log dose", systemImage: "checkmark.circle.fill", action: onLog)
                    Button("Skip", systemImage: "xmark.circle", role: .destructive, action: onSkip)
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                Button(action: onLog) {
                    Text("Log")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)

            case .done:
                Label("Done", systemImage: "checkmark.circle.fill")
                    .labelStyle(.iconOnly)
                    .font(.title2)
                    .foregroundStyle(.green)

            case .skipped:
                Label("Skipped", systemImage: "xmark.circle.fill")
                    .labelStyle(.iconOnly)
                    .font(.title2)
                    .foregroundStyle(.orange)
            }
        }
        .card(padding: 14)
    }
}

private struct LoggedRow: View {
    let log: DoseLog

    var body: some View {
        HStack(spacing: 12) {
            PeptideBadge(
                symbolName: log.peptide?.symbolName ?? "syringe.fill",
                colorHex: log.peptide?.colorHex ?? "#7C8794",
                size: 32
            )
            VStack(alignment: .leading, spacing: 2) {
                Text(log.peptide?.name ?? "Dose")
                    .font(.subheadline.weight(.semibold))
                HStack(spacing: 6) {
                    if log.skipped {
                        Text("Skipped").foregroundStyle(.orange)
                    } else {
                        Text(DoseFormatter.formatMcg(log.doseMcg))
                        Text("·")
                        Text(DoseFormatter.formatUnits(log.syringeUnits))
                    }
                    Text("·")
                    Text(DateDisplay.timeOfDay.string(from: log.takenAt))
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            if let site = log.site, !log.skipped {
                Text(site.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .card(padding: 12)
    }
}

#Preview {
    TodayView()
        .modelContainer(SampleData.makeInMemoryContainer())
}
