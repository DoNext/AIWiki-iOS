import SwiftUI

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
        }
    }
}
