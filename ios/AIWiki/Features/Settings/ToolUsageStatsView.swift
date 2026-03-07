import SwiftUI
import Charts

struct UsageData: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct ToolUsageStatsView: View {
    @EnvironmentObject private var store: AppStore
    
    private var chartData: [UsageData] {
        let calendar = Calendar.current
        let events = store.checkInsInLast7Days()
        
        // Group by day for the last 7 days
        var results: [UsageData] = []
        for i in 0..<7 {
            let day = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            let count = events.filter { calendar.isDate($0.date, inSameDayAs: day) }.count
            // Using a reversed order for display (oldest to newest)
            results.insert(UsageData(date: day, count: count), at: 0)
        }
        return results
    }
    
    private var categoryData: [(category: String, count: Int)] {
        let events = store.checkInEvents
        let grouped = Dictionary(grouping: events, by: \.category)
        return grouped.map { ($0.key, $0.value.count) }
            .sorted { $0.count > $1.count }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // weekly activity chart
                VStack(alignment: .leading, spacing: 16) {
                    Text("最近 7 天使用趋势")
                        .font(.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    if #available(iOS 16.0, *) {
                        Chart {
                            ForEach(chartData) { data in
                                BarMark(
                                    x: .value("日期", data.date, unit: .day),
                                    y: .value("次数", data.count)
                                )
                                .foregroundStyle(AppGradients.accent)
                                .cornerRadius(4)
                            }
                        }
                        .frame(height: 200)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day)) { _ in
                                AxisValueLabel(format: .dateTime.month().day())
                            }
                        }
                    } else {
                        Text("iOS 16 以下版本暂不支持图表显示")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(16)
                .cardStyle()
                
                // Category distribution
                VStack(alignment: .leading, spacing: 16) {
                    Text("兴趣领域分布")
                        .font(.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    if categoryData.isEmpty {
                        Text("暂无数据，快去给 AI 工具打卡吧！")
                            .font(.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 20)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(categoryData, id: \.category) { item in
                                HStack {
                                    Text(item.category)
                                        .font(.subheadline)
                                        .foregroundColor(AppColors.textPrimary)
                                    Spacer()
                                    ProgressView(value: Double(item.count), total: Double(store.checkInEvents.count))
                                        .frame(width: 150)
                                        .tint(AppColors.accent)
                                    Text("\(item.count) 次")
                                        .font(.caption)
                                        .foregroundColor(AppColors.textSecondary)
                                        .frame(width: 40, alignment: .trailing)
                                }
                            }
                        }
                    }
                }
                .padding(16)
                .cardStyle()
                
                // Tips
                VStack(alignment: .leading, spacing: 10) {
                    Label("打卡意义", systemImage: "info.circle")
                        .font(.headline)
                        .foregroundColor(AppColors.accent)
                    Text("通过记录你的 AI 工具使用习惯，AIWiki 能更精准地为你推荐适合的生产力工具。")
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(16)
                .background(AppColors.cardHighlight)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("使用统计")
    }
}
