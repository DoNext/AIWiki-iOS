import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showingQuiz = false

    private var bookmarkedScenarios: [TaskScenario] {
        ScenarioLibrary.all.filter { store.bookmarkedScenarioIDs.contains($0.id) }
    }

    private var featuredTools: [AITool] {
        let featured = ["deepseek", "midjourney", "cursor", "elevenlabs", "runway", "claude", "gamma", "canva-ai"]
        return featured.compactMap { id in store.tools.first { $0.id == id } }
    }

    private var recentTools: [AITool] {
        Array(store.tools.suffix(8).reversed())
    }

    private var dailyTip: (title: String, content: String) {
        let tips = [
            ("如何提问更有效？", "采用『背景 + 任务 + 限制 + 输出格式』结构，AI 回答准确率显著提升。"),
            ("减少 AI 幻觉", "在提示词中明确加入『如果你不知道，请明确告知，不要编造』。"),
            ("长文总结策略", "先让 AI 提取大纲目录，再针对特定章节深入提问，避免遗漏关键信息。"),
            ("角色扮演", "让 AI 扮演特定专家（如：资深程序员、营销总监），获取更专业的回答视角。"),
            ("提供示例 (Few-Shot)", "在要求 AI 输出复杂格式时，先提供一个你期望的格式示例。")
        ]
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return tips[dayOfYear % tips.count]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Top Actions (Search & Quiz side-by-side)
                HStack(spacing: 12) {
                    // Search entry
                    NavigationLink {
                        SearchView()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(AppColors.textSecondary)
                            Text("搜索 AI 工具...")
                                .foregroundColor(AppColors.textSecondary)
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(AppColors.card)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // Native Quiz Entry
                    Button {
                        showingQuiz = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "wand.and.stars")
                                .font(.subheadline)
                            Text("帮我选")
                                .font(.subheadline.weight(.semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(AppGradients.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }

                // Daily Tip
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.orange)
                        Text("今日 AI 技巧")
                            .font(.headline)
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(dailyTip.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.textPrimary)
                        Text(dailyTip.content)
                            .font(.footnote)
                            .foregroundColor(AppColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppColors.accent.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppColors.accent.opacity(0.3), lineWidth: 1)
                )

                // Featured tools (horizontal scroll)
                sectionHeader("🔥 热门推荐")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(featuredTools) { tool in
                            NavigationLink {
                                ToolDetailView(tool: tool)
                            } label: {
                                featuredToolCard(tool)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Personalized recommendations
                let recommended = store.recommendedTools()
                if !recommended.isEmpty {
                    sectionHeader("🎯 为你推荐")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(recommended) { tool in
                                NavigationLink {
                                    ToolDetailView(tool: tool)
                                } label: {
                                    featuredToolCard(tool)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                // New tools
                sectionHeader("🆕 新增工具")
                VStack(spacing: 10) {
                    ForEach(recentTools) { tool in
                        NavigationLink {
                            ToolDetailView(tool: tool)
                        } label: {
                            ToolListRow(tool: tool)
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Bookmarked scenarios
                if !bookmarkedScenarios.isEmpty {
                    sectionHeader("📌 收藏任务")
                    VStack(spacing: 10) {
                        ForEach(bookmarkedScenarios) { scenario in
                            NavigationLink {
                                ScenarioDetailView(scenario: scenario)
                            } label: {
                                scenarioCard(scenario)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Scenarios
                sectionHeader("💡 我想完成什么")
                VStack(spacing: 10) {
                    ForEach(ScenarioLibrary.all) { scenario in
                        NavigationLink {
                            ScenarioDetailView(scenario: scenario)
                        } label: {
                            scenarioCard(scenario)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("AIWiki")
        .fullScreenCover(isPresented: $showingQuiz) {
            ToolQuizView()
        }
    }

    // MARK: - Sub Views

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(AppColors.textPrimary)
    }

    private func featuredToolCard(_ tool: AITool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ToolAvatar(name: tool.name, size: 48)

            Text(tool.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(1)

            Text(tool.intro)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
                .lineLimit(2)
                .frame(height: 32, alignment: .top)

            HStack(spacing: 4) {
                Image(systemName: CategoryIcon.symbol(for: tool.category))
                    .font(.caption2)
                Text(tool.category)
                    .font(.caption2)
            }
            .foregroundColor(AppColors.accent)
        }
        .frame(width: 140)
        .padding(14)
        .cardStyle()
    }

    private func scenarioCard(_ scenario: TaskScenario) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(scenario.title)
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            Text(scenario.subtitle)
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .cardStyle()
    }
}
