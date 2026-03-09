import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        TabView(selection: $store.selectedTab) {
            Tab("首页", systemImage: "house.fill", value: .home) {
                NavigationStack {
                    HomeView()
                }
            }

            Tab("分类", systemImage: "square.grid.2x2.fill", value: .categories) {
                NavigationStack {
                    CategoriesView()
                }
            }

            Tab("对比", systemImage: "arrow.left.arrow.right", value: .compare) {
                NavigationStack {
                    CompareView()
                }
            }

            Tab("收藏", systemImage: "heart.fill", value: .favorites) {
                NavigationStack {
                    FavoritesView()
                }
            }

            Tab("设置", systemImage: "gearshape.fill", value: .settings) {
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .tint(AppColors.accent)
        .onReceive(NotificationCenter.default.publisher(for: .openPromptStudio)) { _ in
            store.selectedTab = .home
            store.showPromptStudio = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .openDashboard)) { _ in
            store.selectedTab = .settings
            store.showStats = true
        }
    }
}
