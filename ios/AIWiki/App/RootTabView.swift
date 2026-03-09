import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        TabView(selection: $store.selectedTab) {
            Tab(L10n.text(L10n.Tab.home), systemImage: "house.fill", value: .home) {
                NavigationStack {
                    HomeView()
                }
            }

            Tab(L10n.text(L10n.Tab.categories), systemImage: "square.grid.2x2.fill", value: .categories) {
                NavigationStack {
                    CategoriesView()
                }
            }

            Tab(L10n.text(L10n.Tab.compare), systemImage: "arrow.left.arrow.right", value: .compare) {
                NavigationStack {
                    CompareView()
                }
            }

            Tab(L10n.text(L10n.Tab.favorites), systemImage: "heart.fill", value: .favorites) {
                NavigationStack {
                    FavoritesView()
                }
            }

            Tab(L10n.text(L10n.Tab.settings), systemImage: "gearshape.fill", value: .settings) {
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
