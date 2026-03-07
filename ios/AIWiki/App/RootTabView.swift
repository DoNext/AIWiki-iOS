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
            // 这里还可以进一步触发 HomeView 内部的状态，例如弹出 Sheet
            // 但目前的 HomeView 是根据 store.showingPromptStudio 等状态来显示的
            // 我们可以在 AppStore 中添加全局触发
        }
        .onReceive(NotificationCenter.default.publisher(for: .openDashboard)) { _ in
            store.selectedTab = 4 // 跳转到设置/仪表盘页
        }
    }
}
