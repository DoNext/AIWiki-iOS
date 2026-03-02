import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }

            NavigationStack {
                CategoriesView()
            }
                .tabItem {
                    Label("分类", systemImage: "square.grid.2x2.fill")
                }

            NavigationStack {
                FavoritesView()
            }
                .tabItem {
                    Label("收藏", systemImage: "heart.fill")
                }

            NavigationStack {
                SettingsView()
            }
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
        }
        .tint(AppColors.accent)
    }
}
