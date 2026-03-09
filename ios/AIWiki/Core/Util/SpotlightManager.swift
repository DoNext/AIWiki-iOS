import Foundation
@preconcurrency import CoreSpotlight
import UniformTypeIdentifiers

@MainActor
class SpotlightManager {
    static let shared = SpotlightManager()
    
    private init() {}
    
    func indexTools(_ tools: [AITool]) {
        print("Spotlight: Starting indexing for \(tools.count) tools...")
        
        guard !tools.isEmpty else {
            print("Spotlight: ABORT - No tools to index.")
            return
        }
        
        let searchableItems = tools.map { tool -> CSSearchableItem in
            let attributeSet = CSSearchableItemAttributeSet(contentType: .data)
            attributeSet.title = tool.localizedName
            attributeSet.displayName = tool.localizedName
            attributeSet.contentDescription = tool.localizedIntro
            
            var keywords = [
                tool.localizedCategory,
                tool.localizedCompany,
                L10n.text("spotlight.keyword.ai"),
                L10n.text("spotlight.keyword.tool"),
                L10n.text("spotlight.keyword.assistant")
            ] + tool.localizedFeatures
            keywords.append(tool.id)
            attributeSet.keywords = keywords
            attributeSet.alternateNames = [tool.id]
            
            print("Spotlight: Preparing item [\(tool.id)] -> \(tool.localizedName)")
            
            return CSSearchableItem(
                uniqueIdentifier: tool.id,
                domainIdentifier: Bundle.main.bundleIdentifier ?? "com.next.wiki",
                attributeSet: attributeSet
            )
        }
        
        print("Spotlight: Clearing old index...")
        CSSearchableIndex.default().deleteAllSearchableItems { error in
            if let error = error {
                print("Spotlight: Clear ERROR - \(error.localizedDescription)")
            } else {
                print("Spotlight: Clear SUCCESS. Now indexing...")
                CSSearchableIndex.default().indexSearchableItems(searchableItems) { error in
                    if let error = error {
                        print("Spotlight: Indexing ERROR - \(error.localizedDescription)")
                    } else {
                            print("Spotlight: Indexing SUCCESS for \(tools.count) items.")
                            if let first = tools.first {
                            print("Spotlight: Verify by searching for '\(first.localizedName)' or '\(first.localizedCategory)'")
                        }
                    }
                }
            }
        }
    }
    
    func clearIndex() {
        CSSearchableIndex.default().deleteAllSearchableItems { error in
            if let error = error {
                print("Spotlight clear error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - App Intents
import AppIntents

struct OpenPromptStudioIntent: AppIntent {
    static var title: LocalizedStringResource = "intent.open_prompt_studio.title"
    static var description = IntentDescription("intent.open_prompt_studio.description")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        NotificationCenter.default.post(name: .openPromptStudio, object: nil)
        return .result()
    }
}

struct ViewDashboardIntent: AppIntent {
    static var title: LocalizedStringResource = "intent.view_dashboard.title"
    static var description = IntentDescription("intent.view_dashboard.description")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        NotificationCenter.default.post(name: .openDashboard, object: nil)
        return .result()
    }
}

struct RandomToolIntent: AppIntent {
    static var title: LocalizedStringResource = "intent.random_tool.title"
    static var description = IntentDescription("intent.random_tool.description")
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let tips = [
            L10n.text("intent.random.tip.midjourney"),
            L10n.text("intent.random.tip.chatgpt"),
            L10n.text("intent.random.tip.claude"),
            L10n.text("intent.random.tip.runway"),
            L10n.text("intent.random.tip.gamma")
        ]
        let recommendation = tips.randomElement() ?? L10n.text("intent.random.tip.default")
        return .result(
            value: recommendation,
            dialog: IntentDialog(stringLiteral: "\(L10n.text("intent.random.dialog_prefix"))\(recommendation)")
        )
    }
}

struct AIWikiShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenPromptStudioIntent(),
            phrases: [
                "Open Prompt Studio in \(.applicationName)",
                "Create prompts with \(.applicationName)",
                "Open \(.applicationName) prompts"
            ],
            shortTitle: LocalizedStringResource("intent.open_prompt_studio.short_title"),
            systemImageName: "wand.and.stars"
        )
        
        AppShortcut(
            intent: ViewDashboardIntent(),
            phrases: [
                "Show my AI dashboard in \(.applicationName)",
                "Show \(.applicationName) dashboard",
                "View \(.applicationName) skill analysis"
            ],
            shortTitle: LocalizedStringResource("intent.view_dashboard.short_title"),
            systemImageName: "chart.bar.xaxis"
        )
    }
}

extension NSNotification.Name {
    static let openPromptStudio = NSNotification.Name("aiwiki.openPromptStudio")
    static let openDashboard = NSNotification.Name("aiwiki.openDashboard")
}
