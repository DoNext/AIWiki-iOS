import SwiftUI

@main
struct AIWikiApp: App {
    @StateObject private var store = AppStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .preferredColorScheme(store.theme.colorScheme)
        }
    }
}
