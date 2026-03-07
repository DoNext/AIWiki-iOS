import SwiftUI
import CoreSpotlight

@main
struct AIWikiApp: App {
    @StateObject private var store = AppStore()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                RootTabView()
                    .environmentObject(store)
                    .preferredColorScheme(store.theme.colorScheme)

                if showSplash {
                    SplashView {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showSplash = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
        .onContinueUserActivity(CSSearchableItemActionType) { userActivity in
            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                if let tool = store.tool(withID: uniqueIdentifier) {
                    store.deepLinkTool = tool
                }
            }
        }
    }
}
}
