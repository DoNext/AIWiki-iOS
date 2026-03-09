import SwiftUI

private enum FavoriteSort: String, CaseIterable, Identifiable {
    case nameAsc
    case nameDesc

    var id: String { rawValue }

    var title: String {
        switch self {
        case .nameAsc: return L10n.text(L10n.Favorites.sortAZ)
        case .nameDesc: return L10n.text(L10n.Favorites.sortZA)
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
            tool.localizedSearchText.contains(keyword)
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
                VStack(spacing: 12) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.textSecondary)
                    Text(L10n.text(L10n.Favorites.empty))
                        .font(.headline)
                        .foregroundColor(AppColors.textSecondary)
                    Text(L10n.text(L10n.Favorites.emptyHint))
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary.opacity(0.7))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.background.ignoresSafeArea())
            } else if favoriteTools.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.textSecondary)
                    Text(L10n.text(L10n.Favorites.noMatch))
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.background.ignoresSafeArea())
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(favoriteTools, id: \.id) { tool in
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
        .searchable(text: $query, prompt: L10n.text(L10n.Search.favoritesPrompt))
        .navigationTitle(L10n.text(L10n.Favorites.title))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker(L10n.text(L10n.Favorites.sort), selection: $sort) {
                        ForEach(FavoriteSort.allCases) { option in
                            Text(option.title).tag(option)
                        }
                    }
                    Button(L10n.text(L10n.Favorites.clearAll), role: .destructive) {
                        store.clearFavorites()
                        query = ""
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(AppColors.accent)
                }
            }
        }
    }
}
