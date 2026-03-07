import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        TabView(selection: $store.selectedTab) {
            NavigationStack {
                HomeView()
            }
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)

            NavigationStack {
                CategoriesView()
            }
                .tabItem {
                    Label("分类", systemImage: "square.grid.2x2.fill")
                }
                .tag(1)

            NavigationStack {
                CompareView()
            }
                .tabItem {
                    Label("对比", systemImage: "arrow.left.arrow.right")
                }
                .tag(2)

            NavigationStack {
                FavoritesView()
            }
                .tabItem {
                    Label("收藏", systemImage: "heart.fill")
                }
                .tag(3)

            NavigationStack {
                SettingsView()
            }
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(AppColors.accent)
        .onReceive(NotificationCenter.default.publisher(for: .openPromptStudio)) { _ in
            store.selectedTab = 0 // 回到首页
            store.showPromptStudio = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .openDashboard)) { _ in
            store.selectedTab = 4 // 跳转到设置页
            store.showStats = true
        }
    }
}
