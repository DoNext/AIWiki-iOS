import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var store: AppStore
    @State private var query: String = ""
    @FocusState private var isSearchFocused: Bool
    @AppStorage("searchHistory") private var searchHistoryData: Data = Data()

    private var searchHistory: [String] {
        (try? JSONDecoder().decode([String].self, from: searchHistoryData)) ?? []
    }

    private var results: [AITool] {
        store.filteredTools(query: query)
    }

    private var isSearching: Bool {
        !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private let hotSearches = ["DeepSeek", "Midjourney", "Cursor", "Claude", "Whisper", "Notion AI"]

    var body: some View {
        Group {
            if let error = store.loadError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if !isSearching {
                // Show search history & hot search when not searching
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Hot searches
                        VStack(alignment: .leading, spacing: 10) {
                            Text("🔥 热门搜索")
                                .font(.headline)
                                .foregroundColor(AppColors.textPrimary)
                            FlowLayout(spacing: 8) {
                                ForEach(hotSearches, id: \.self) { keyword in
                                    Button {
                                        query = keyword
                                    } label: {
                                        Text(keyword)
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.textPrimary)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(
                                                Capsule()
                                                    .fill(AppColors.card)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        // Search history
                        if !searchHistory.isEmpty {
                            HStack {
                                Text("🕐 搜索历史")
                                    .font(.headline)
                                    .foregroundColor(AppColors.textPrimary)
                                Spacer()
                                Button("清除") {
                                    searchHistoryData = Data()
                                }
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                            }

                            VStack(spacing: 0) {
                                ForEach(searchHistory, id: \.self) { keyword in
                                    Button {
                                        query = keyword
                                    } label: {
                                        HStack {
                                            Image(systemName: "clock.arrow.circlepath")
                                                .font(.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                            Text(keyword)
                                                .font(.subheadline)
                                                .foregroundColor(AppColors.textPrimary)
                                            Spacer()
                                        }
                                        .padding(.vertical, 10)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                            .cardStyle()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .background(AppColors.background.ignoresSafeArea())
            } else if results.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundColor(AppColors.textSecondary)
                    Text("没有找到匹配的工具")
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.background.ignoresSafeArea())
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(results, id: \.id) { tool in
                            NavigationLink {
                                ToolDetailView(tool: tool)
                            } label: {
                                ToolListRow(tool: tool)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .background(AppColors.background.ignoresSafeArea())
            }
        }
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "搜索名称、简介、功能")
        .focused($isSearchFocused)
        .onAppear {
            // Delay focus slightly to ensure smooth transition
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isSearchFocused = true
            }
        }
        .onSubmit(of: .search) {
            saveSearchHistory(query)
        }
        .navigationTitle("搜索")
    }

    private func saveSearchHistory(_ keyword: String) {
        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var history = searchHistory
        history.removeAll { $0 == trimmed }
        history.insert(trimmed, at: 0)
        if history.count > 10 { history = Array(history.prefix(10)) }
        searchHistoryData = (try? JSONEncoder().encode(history)) ?? Data()
    }
}
