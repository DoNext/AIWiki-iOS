import SwiftUI

private enum FavoriteSort: String, CaseIterable, Identifiable {
    case nameAsc
    case nameDesc

    var id: String { rawValue }

    var title: String {
        switch self {
        case .nameAsc: return "名称 A-Z"
        case .nameDesc: return "名称 Z-A"
        }
    }
}

struct FavoritesView: View {
    @EnvironmentObject private var store: AppStore
    @State private var query: String = ""
    @State private var sort: FavoriteSort = .nameAsc

    private var favoriteTools: [AITool] {
        let keyword = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let filtered = keyword.isEmpty ? store.favoriteTools() : store.favoriteTools().filter { tool in
            let text = "\(tool.name) \(tool.intro) \(tool.features.joined(separator: " "))".lowercased()
            return text.contains(keyword)
        }
        switch sort {
        case .nameAsc:
            return filtered.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        case .nameDesc:
            return filtered.sorted { $0.name.localizedCompare($1.name) == .orderedDescending }
        }
    }

    var body: some View {
        Group {
            if let error = store.loadError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if store.favoriteTools().isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "star")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("还没有收藏")
                        .foregroundColor(.secondary)
                }
            } else if favoriteTools.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("收藏中无匹配结果")
                        .foregroundColor(.secondary)
                }
            } else {
                List(favoriteTools, id: \.id) { tool in
                    NavigationLink {
                        ToolDetailView(tool: tool)
                    } label: {
                        ToolListRow(tool: tool)
                    }
                }
                .listStyle(.plain)
            }
        }
        .searchable(text: $query, prompt: "搜索收藏")
        .navigationTitle("收藏")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker("排序", selection: $sort) {
                        ForEach(FavoriteSort.allCases) { option in
                            Text(option.title).tag(option)
                        }
                    }
                    Button("清空收藏", role: .destructive) {
                        store.clearFavorites()
                        query = ""
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}
