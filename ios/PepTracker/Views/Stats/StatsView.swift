import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Query(sort: \DoseLog.takenAt, order: .reverse) private var logs: [DoseLog]
    @Query(filter: #Predicate<Peptide> { !$0.archived }, sort: \Peptide.name) private var peptides: [Peptide]

    @State private var range: Range = .week

    enum Range: String, CaseIterable, Identifiable {
        case week, month, ninety
        var id: String { rawValue }
        var label: String {
            switch self {
            case .week: return "7 days"
            case .month: return "30 days"
            case .ninety: return "90 days"
            }
        }
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .ninety: return 90
            }
        }
    }

    private var rangeStart: Date {
        Calendar.current.date(byAdding: .day, value: -range.days + 1, to: Calendar.current.startOfDay(for: .now)) ?? .now
    }

    private var inRangeLogs: [DoseLog] {
        logs.filter { $0.takenAt >= rangeStart && !$0.skipped }
    }

    private var dailyCounts: [DayBucket] {
        let cal = Calendar.current
        var buckets: [Date: Int] = [:]
        for offset in 0..<range.days {
            if let day = cal.date(byAdding: .day, value: -offset, to: cal.startOfDay(for: .now)) {
                buckets[day] = 0
            }
        }
        for log in inRangeLogs {
            let day = cal.startOfDay(for: log.takenAt)
            buckets[day, default: 0] += 1
        }
        return buckets
            .map { DayBucket(date: $0.key, count: $0.value) }
            .sorted { $0.date < $1.date }
    }

    private var siteCounts: [SiteBucket] {
        var counts: [InjectionSite: Int] = [:]
        for log in inRangeLogs {
            if let site = log.site { counts[site, default: 0] += 1 }
        }
        return counts.map { SiteBucket(site: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }

    private var totalDoses: Int { inRangeLogs.count }

    private var totalMg: Double {
        inRangeLogs.reduce(0) { $0 + $1.doseMcg } / 1000.0
    }

    private var streak: Int {
        let cal = Calendar.current
        let loggedDays = Set(logs.filter { !$0.skipped }.map { cal.startOfDay(for: $0.takenAt) })
        var count = 0
        var cursor = cal.startOfDay(for: .now)
        while loggedDays.contains(cursor) {
            count += 1
            guard let prev = cal.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = prev
        }
        return count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Picker("Range", selection: $range.animation()) {
                        ForEach(Range.allCases) { r in
                            Text(r.label).tag(r)
                        }
                    }
                    .pickerStyle(.segmented)

                    summaryCard
                    activityChart
                    siteRotationCard
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Stats")
        }
    }

    private var summaryCard: some View {
        HStack(spacing: 0) {
            StatTile(value: "\(totalDoses)", label: "Doses")
            Divider().frame(height: 36)
            StatTile(value: "\(formatMg(totalMg))", label: "mg total")
            Divider().frame(height: 36)
            StatTile(value: "\(streak)", label: "Day streak")
        }
        .card()
    }

    private var activityChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Daily activity")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            Chart(dailyCounts) { bucket in
                BarMark(
                    x: .value("Day", bucket.date, unit: .day),
                    y: .value("Doses", bucket.count)
                )
                .foregroundStyle(Color.accentColor.gradient)
                .cornerRadius(4)
            }
            .frame(height: 180)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: max(1, range.days / 7))) { value in
                    AxisValueLabel(format: .dateTime.day().month(.narrow))
                    AxisGridLine()
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .card()
    }

    private var siteRotationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Site rotation")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            if siteCounts.isEmpty {
                Text("No injection sites recorded yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(siteCounts) { bucket in
                    HStack {
                        Text(bucket.site.displayName)
                            .font(.subheadline)
                        Spacer()
                        Text("\(bucket.count)")
                            .font(.subheadline.weight(.semibold))
                            .monospacedDigit()
                    }
                    ProgressView(value: Double(bucket.count), total: Double(siteCounts.first?.count ?? 1))
                        .tint(Color.accentColor)
                }
            }
        }
        .card()
    }

    private func formatMg(_ mg: Double) -> String {
        if mg >= 100 { return String(format: "%.0f", mg) }
        return String(format: "%.2f", mg)
    }
}

private struct StatTile: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.title3.weight(.bold)).monospacedDigit()
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct DayBucket: Identifiable {
    let date: Date
    let count: Int
    var id: Date { date }
}

private struct SiteBucket: Identifiable {
    let site: InjectionSite
    let count: Int
    var id: String { site.rawValue }
}

#Preview {
    StatsView()
        .modelContainer(SampleData.makeInMemoryContainer())
}
