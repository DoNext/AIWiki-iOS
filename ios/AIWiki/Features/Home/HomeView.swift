import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppStore

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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Search entry
                NavigationLink {
                    SearchView()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppColors.textSecondary)
                        Text("搜索 AI 工具...")
                            .foregroundColor(AppColors.textSecondary)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(AppColors.card)
                    )
                }
                .buttonStyle(.plain)

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
