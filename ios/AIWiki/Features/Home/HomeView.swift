import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppStore

    private var bookmarkedScenarios: [TaskScenario] {
        ScenarioLibrary.all.filter { store.bookmarkedScenarioIDs.contains($0.id) }
    }

    var body: some View {
        List {
            if !bookmarkedScenarios.isEmpty {
                Section("收藏任务") {
                    ForEach(bookmarkedScenarios) { scenario in
                        NavigationLink {
                            ScenarioDetailView(scenario: scenario)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(scenario.title)
                                    .font(.headline)
                                Text(scenario.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }

            Section("我想完成什么") {
                ForEach(ScenarioLibrary.all) { scenario in
                    NavigationLink {
                        ScenarioDetailView(scenario: scenario)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(scenario.title)
                                .font(.headline)
                            Text(scenario.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }

            Section("工具检索") {
                NavigationLink {
                    SearchView()
                } label: {
                    Label("按名称/功能搜索工具", systemImage: "magnifyingglass")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("场景")
    }
}
