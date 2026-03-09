import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var columns: [GridItem] {
        let count = sizeClass == .regular ? 3 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: count)
    }

    var body: some View {
        Group {
            if let error = store.loadError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(store.categoryGroups(), id: \.name) { item in
                            NavigationLink {
                                CategoryToolsView(category: item.name)
                            } label: {
                                VStack(spacing: 10) {
                                    Image(systemName: CategoryIcon.symbol(for: item.name))
                                        .font(.title)
                                        .foregroundStyle(AppGradients.accent)
                                    Text(L10n.text(item.name))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(AppColors.textPrimary)
                                    Text(L10n.format("%d 个工具", item.count))
                                        .font(.caption)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                                .cardStyle()
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
        .navigationTitle("分类")
    }
}
