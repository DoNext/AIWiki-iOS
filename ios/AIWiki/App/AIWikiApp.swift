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
        .onOpenURL { url in
            guard url.scheme == "aiwiki" else { return }
            
            let path = url.path.trimmingCharacters(in: ["/"])
            let host = url.host ?? ""
            
            switch host {
            case "tab":
                if let tabIndex = Int(path), let tab = AppTab(rawValue: tabIndex) {
                    store.selectedTab = tab
                }
            case "tool":
                if let tool = store.tool(withID: path) {
                    store.deepLinkTool = tool
                }
            case "compare":
                store.selectedTab = .compare
            default:
                break
            }
        }
    }
}
}
