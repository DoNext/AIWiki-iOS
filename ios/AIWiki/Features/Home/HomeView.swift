import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showingQuiz = false
    @State private var showingAIConsole = false
    @State private var searchText = ""

    private var bookmarkedScenarios: [TaskScenario] {
        ScenarioLibrary.all.filter { store.bookmarkedScenarioIDs.contains($0.id) }
    }

    private var featuredTools: [AITool] {
        let featured = ["midjourney", "cursor", "elevenlabs", "runway", "gamma", "canva-ai"]
        return featured.compactMap { id in store.tools.first { $0.id == id } }
    }

    private var recentTools: [AITool] {
        Array(store.tools.suffix(8).reversed())
    }

    private var dailyTip: (title: String, content: String) {
        let tips = [
            ("home.tip.ask_better.title", "home.tip.ask_better.body"),
            ("home.tip.reduce_hallucinations.title", "home.tip.reduce_hallucinations.body"),
            ("home.tip.long_summary.title", "home.tip.long_summary.body"),
            ("home.tip.role_play.title", "home.tip.role_play.body"),
            ("home.tip.few_shot.title", "home.tip.few_shot.body")
        ]
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let tip = tips[dayOfYear % tips.count]
        return (L10n.text(tip.0), L10n.text(tip.1))
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
                            Text(L10n.text(L10n.Home.searchPlaceholder))
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
                            Text(L10n.text(L10n.Home.quiz))
                                .font(.subheadline.weight(.semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(AppGradients.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }

                // AI News & Tips Widget
                AINewsWidget()
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppColors.accent.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppColors.accent.opacity(0.3), lineWidth: 1)
                )

                // AI Hub Console Entry
                Button {
                    showingAIConsole = true
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.2))
                                .frame(width: 44, height: 44)
                            Image(systemName: "cpu.fill")
                                .foregroundColor(.orange)
                                .font(.title3)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(L10n.text(L10n.Home.consoleTitle))
                                .font(.headline)
                                .foregroundColor(AppColors.textPrimary)
                            Text(L10n.text(L10n.Home.consoleSubtitle))
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(AppColors.card)
                    )
                }
                .sheet(isPresented: $showingAIConsole) {
                    AIConsoleView()
                }

                // Prompt Studio Entry
                Button {
                    store.showPromptStudio = true
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(AppGradients.accent.opacity(0.2))
                                .frame(width: 44, height: 44)
                            Image(systemName: "wand.and.stars.inverse")
                                .foregroundColor(AppColors.accent)
                                .font(.title3)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(L10n.text(L10n.Home.promptStudioTitle))
                                .font(.headline)
                                .foregroundColor(AppColors.textPrimary)
                            Text(L10n.text(L10n.Home.promptStudioSubtitle))
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(AppColors.card)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(AppColors.accent.opacity(0.1), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)

                // Featured tools (horizontal scroll)
                sectionHeader(L10n.text(L10n.Home.featured))
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
                    sectionHeader(L10n.text(L10n.Home.recommended))
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
                sectionHeader(L10n.text(L10n.Home.recent))
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
                    sectionHeader(L10n.text(L10n.Home.bookmarked))
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
                sectionHeader(L10n.text(L10n.Home.scenarios))
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
        .navigationTitle(L10n.text(L10n.Home.title))
        .fullScreenCover(isPresented: $showingQuiz) {
            ToolQuizView()
        }
        .sheet(isPresented: $store.showPromptStudio) {
            PromptStudioView()
        }
        .sheet(item: $store.deepLinkTool) { tool in
            NavigationStack {
                ToolDetailView(tool: tool)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(L10n.text(L10n.Common.done)) { store.deepLinkTool = nil }
                        }
                    }
            }
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
            ToolAvatar(name: tool.localizedName, size: 48)

            Text(tool.localizedName)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(1)

                            Text(tool.localizedIntro)
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                                .lineLimit(2)
                .frame(height: 32, alignment: .top)

            HStack(spacing: 4) {
                Image(systemName: CategoryIcon.symbol(for: tool.category))
                    .font(.caption2)
                Text(tool.localizedCategory)
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
            Text(scenario.localizedTitle)
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            Text(scenario.localizedSubtitle)
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .cardStyle()
    }
}
