import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppStore

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private var bookmarkedScenarios: [TaskScenario] {
        ScenarioLibrary.all.filter { store.bookmarkedScenarioIDs.contains($0.id) }
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

                // Bookmarked scenarios
                if !bookmarkedScenarios.isEmpty {
                    sectionHeader("收藏任务")
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
                sectionHeader("我想完成什么")
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

                // Category grid
                sectionHeader("工具分类")
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(store.categoryGroups(), id: \.name) { item in
                        NavigationLink {
                            CategoryToolsView(category: item.name)
                        } label: {
                            categoryCard(name: item.name, count: item.count)
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

    private func categoryCard(name: String, count: Int) -> some View {
        VStack(spacing: 10) {
            Image(systemName: CategoryIcon.symbol(for: name))
                .font(.title2)
                .foregroundStyle(AppGradients.accent)
            Text(name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.textPrimary)
            Text("\(count) 个工具")
                .font(.caption2)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .cardStyle()
    }
}
