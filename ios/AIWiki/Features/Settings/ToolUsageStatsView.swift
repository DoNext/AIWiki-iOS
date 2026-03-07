import SwiftUI
import Charts

struct ToolUsageStatsView: View {
    @EnvironmentObject private var store: AppStore
    
    // 维度定义
    enum SkillDimension: String, CaseIterable {
        case creative = "创意/绘图"
        case writing = "文案/翻译"
        case coding = "编程/开发"
        case analytics = "数据/分析"
        case generic = "通用/助手"
        
        static func from(category: String) -> SkillDimension {
            switch category {
            case "图像生成", "视频生成", "艺术设计": return .creative
            case "文案写作", "语言翻译", "文档处理": return .writing
            case "编程开发", "代码补全": return .coding
            case "数据分析", "学术搜索": return .analytics
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
            // 基础分 1.0，根据打卡频率加成，最高 5.0
            return min(5.0, 1.0 + (Double(count) / Double(total) * 10.0))
        }
    }
    
    private var userTitle: (name: String, icon: String, description: String) {
        let scores = skillScores
        let maxIndex = scores.enumerated().max(by: { $0.element < $1.element })?.offset ?? 0
        let topSkill = SkillDimension.allCases[maxIndex]
        let totalCheckins = store.checkInEvents.count
        
        if totalCheckins < 5 {
            return ("AI 初探者", "leaf.fill", "正在开启你的 AI 探索之旅，多去打卡发现更多工具吧！")
        }
        
        switch topSkill {
        case .creative: return ("光影艺术家", "paintbrush.fill", "你对视觉创意充满热情，是当之无愧的 AI 调色师。")
        case .writing: return ("文字魔法师", "scroll.fill", "文字是你操控 AI 的咒语，沟通与表达是你的强项。")
        case .coding: return ("数字架构师", "cpu.fill", "在代码的世界里，你正利用 AI 构建未来的蓝图。")
        case .analytics: return ("智库观察家", "magnifyingglass.circle.fill", "洞悉数据，挖掘真相，AI 让你拥有了更广阔的视野。")
        case .generic: return ("全能领航员", "safari.fill", "你游走在各类 AI 之间，是一位全能的工具应用专家。")
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
                    Text("AI 核心能力图谱")
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
                        RadarLabelsView(dimensions: SkillDimension.allCases.map { $0.rawValue })
                    }
                    .frame(height: 220)
                    .padding(.vertical, 20)
                }
                .padding(20)
                .cardStyle()
                
                // 3. Activity Trend
                VStack(alignment: .leading, spacing: 16) {
                    Text("活跃趋势")
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
        .navigationTitle("生产力仪表盘")
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
