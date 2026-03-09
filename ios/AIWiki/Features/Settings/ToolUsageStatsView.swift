import SwiftUI
import Charts

struct ToolUsageStatsView: View {
    @EnvironmentObject private var store: AppStore
    
    enum SkillDimension: String, CaseIterable {
        case creative = "stats.dimension.creative"
        case writing = "stats.dimension.writing"
        case coding = "stats.dimension.coding"
        case analytics = "stats.dimension.analytics"
        case generic = "stats.dimension.generic"
        
        static func from(category: String) -> SkillDimension {
            switch category {
            case L10n.Category.imageGeneration, L10n.Category.video, L10n.Category.design:
                return .creative
            case L10n.Category.writing, L10n.Category.marketing:
                return .writing
            case L10n.Category.coding:
                return .coding
            case L10n.Category.dataAnalysis, L10n.Category.search:
                return .analytics
            default: return .generic
            }
        }
    }
    
    private var skillScores: [Double] {
        let events = store.checkInEvents
        var counts: [SkillDimension: Int] = [:]
        SkillDimension.allCases.forEach { counts[$0] = 0 }
        
        for event in events {
            let dim = SkillDimension.from(category: event.category)
            counts[dim, default: 0] += 1
        }
        
        let total = max(1, events.count)
        return SkillDimension.allCases.map { dim in
            let count = counts[dim] ?? 0
            return min(5.0, 1.0 + (Double(count) / Double(total) * 10.0))
        }
    }
    
    private var userTitle: (name: String, icon: String, description: String) {
        let scores = skillScores
        let maxIndex = scores.enumerated().max(by: { $0.element < $1.element })?.offset ?? 0
        let topSkill = SkillDimension.allCases[maxIndex]
        let totalCheckins = store.checkInEvents.count
        
        if totalCheckins < 5 {
            return (
                L10n.text("stats.rank.beginner.title"),
                "leaf.fill",
                L10n.text("stats.rank.beginner.description")
            )
        }
        
        switch topSkill {
        case .creative:
            return (L10n.text("stats.rank.creative.title"), "paintbrush.fill", L10n.text("stats.rank.creative.description"))
        case .writing:
            return (L10n.text("stats.rank.writing.title"), "scroll.fill", L10n.text("stats.rank.writing.description"))
        case .coding:
            return (L10n.text("stats.rank.coding.title"), "cpu.fill", L10n.text("stats.rank.coding.description"))
        case .analytics:
            return (L10n.text("stats.rank.analytics.title"), "magnifyingglass.circle.fill", L10n.text("stats.rank.analytics.description"))
        case .generic:
            return (L10n.text("stats.rank.generic.title"), "safari.fill", L10n.text("stats.rank.generic.description"))
        }
    }

    private var chartData: [UsageData] {
        let calendar = Calendar.current
        let events = store.checkInsInLast7Days()
        var results: [UsageData] = []
        for i in 0..<7 {
            let day = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            let count = events.filter { calendar.isDate($0.date, inSameDayAs: day) }.count
            results.insert(UsageData(date: day, count: count), at: 0)
        }
        return results
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 1. Title & Rank
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(AppGradients.accent.opacity(0.1))
                            .frame(width: 80, height: 80)
                        Image(systemName: userTitle.icon)
                            .font(.system(size: 40))
                            .foregroundColor(AppColors.accent)
                    }
                    
                    Text(userTitle.name)
                        .font(.title2.bold())
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(userTitle.description)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                .background(AppColors.card)
                .cornerRadius(20)
                
                // 2. Skill Radar
                VStack(alignment: .leading, spacing: 16) {
                    Text(L10n.text(L10n.Stats.radarTitle))
                        .font(.headline)
                    
                    ZStack {
                        // Background Web
                        RadarWebShape(dimensions: SkillDimension.allCases.count)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                        
                        // Data
                        RadarShape(data: skillScores, maxValue: 5.0)
                            .fill(AppColors.accent.opacity(0.2))
                        
                        RadarShape(data: skillScores, maxValue: 5.0)
                            .stroke(AppColors.accent, lineWidth: 2)
                        
                        // Labels
                        RadarLabelsView(dimensions: SkillDimension.allCases.map { L10n.text($0.rawValue) })
                    }
                    .frame(height: 220)
                    .padding(.vertical, 20)
                }
                .padding(20)
                .cardStyle()
                
                // 3. Activity Trend
                VStack(alignment: .leading, spacing: 16) {
                    Text(L10n.text(L10n.Stats.trendTitle))
                        .font(.headline)
                    
                    Chart {
                        ForEach(chartData) { data in
                            BarMark(
                                x: .value("Day", data.date, unit: .day),
                                y: .value("Count", data.count)
                            )
                            .foregroundStyle(AppGradients.accent)
                            .cornerRadius(4)
                        }
                    }
                    .frame(height: 180)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisValueLabel(format: .dateTime.month().day())
                        }
                    }
                }
                .padding(20)
                .cardStyle()
            }
            .padding(16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle(L10n.text(L10n.Settings.dashboard))
    }
}

// MARK: - Components
struct RadarLabelsView: View {
    let dimensions: [String]
    
    var body: some View {
        ZStack {
            ForEach(0..<dimensions.count, id: \.self) { i in
                let angle = Double(i) * (2.0 * .pi / Double(dimensions.count)) - .pi / 2.0
                let xOffset = 110.0 * cos(angle)
                let yOffset = 110.0 * sin(angle)
                
                Text(dimensions[i])
                    .font(.caption2.bold())
                    .foregroundColor(AppColors.textSecondary)
                    .offset(x: xOffset, y: yOffset)
            }
        }
    }
}

// MARK: - Helper Shapes
struct UsageData: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct RadarWebShape: Shape {
    let dimensions: Int
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2
            
            // Circles
            for level in 1...4 {
                let r = radius * CGFloat(level) / 4.0
                path.addEllipse(in: CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2))
            }
            
            // Lines
            for i in 0..<dimensions {
                let angle = CGFloat(i) * (2 * .pi / CGFloat(dimensions)) - .pi / 2
                path.move(to: center)
                path.addLine(to: CGPoint(
                    x: center.x + radius * cos(angle),
                    y: center.y + radius * sin(angle)
                ))
            }
        }
    }
}

struct RadarShape: Shape {
    let data: [Double]
    let maxValue: Double
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let count = data.count
            guard count > 2 else { return }
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2
            
            for i in 0..<count {
                let valRatio = CGFloat(data[i] / maxValue)
                let angle = CGFloat(i) * (2 * .pi / CGFloat(count)) - .pi / 2
                let point = CGPoint(
                    x: center.x + radius * valRatio * cos(angle),
                    y: center.y + radius * valRatio * sin(angle)
                )
                if i == 0 { path.move(to: point) }
                else { path.addLine(to: point) }
            }
            path.closeSubpath()
        }
    }
}
