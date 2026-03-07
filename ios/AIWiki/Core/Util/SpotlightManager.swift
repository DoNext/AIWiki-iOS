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
            attributeSet.title = tool.name
            attributeSet.displayName = tool.name
            attributeSet.contentDescription = tool.intro
            
            var keywords = [tool.category, tool.company, "AI", "工具", "助手"] + tool.features
            keywords.append(tool.id)
            attributeSet.keywords = keywords
            attributeSet.alternateNames = [tool.id]
            
            print("Spotlight: Preparing item [\(tool.id)] -> \(tool.name)")
            
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
                            print("Spotlight: Verify by searching for '\(first.name)' or '\(first.category)'")
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
    static var title: LocalizedStringResource = "打开提示词工作室"
    static var description = IntentDescription("立即打开 AIWiki 的提示词工作室开始创作。")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        NotificationCenter.default.post(name: .openPromptStudio, object: nil)
        return .result()
    }
}

struct ViewDashboardIntent: AppIntent {
    static var title: LocalizedStringResource = "查看 AI 生产力仪表盘"
    static var description = IntentDescription("查看您的 AI 技能图谱和打卡统计。")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        NotificationCenter.default.post(name: .openDashboard, object: nil)
        return .result()
    }
}

struct RandomToolIntent: AppIntent {
    static var title: LocalizedStringResource = "随机推荐 AI 工具"
    static var description = IntentDescription("从 AIWiki 库中随机为您推荐一个实用的 AI 工具。")
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let tips = [
            "Midjourney: 顶尖的 AI 艺术生成工具。",
            "ChatGPT: 强大的通用对话助手。",
            "Claude: 擅长长文分析与逻辑推理。",
            "Runway: 领先的 AI 视频创作平台。",
            "Gamma: 自动生成演示文稿的利器。"
        ]
        let recommendation = tips.randomElement() ?? "快去 AIWiki 探索更多工具吧！"
        return .result(value: recommendation, dialog: "为您推荐：\(recommendation)")
    }
}

struct AIWikiShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenPromptStudioIntent(),
            phrases: [
                "在 \(.applicationName) 中打开提示词工作室",
                "使用 \(.applicationName) 创作提示词",
                "打开 \(.applicationName) 提示词"
            ],
            shortTitle: "打开提示词工作室",
            systemImageName: "wand.and.stars"
        )
        
        AppShortcut(
            intent: ViewDashboardIntent(),
            phrases: [
                "在 \(.applicationName) 查看我的 AI 成绩单",
                "显示 \(.applicationName) 仪表盘",
                "查看 \(.applicationName) 技能分析"
            ],
            shortTitle: "查看仪表盘",
            systemImageName: "chart.bar.xaxis"
        )
    }
}

extension NSNotification.Name {
    static let openPromptStudio = NSNotification.Name("aiwiki.openPromptStudio")
    static let openDashboard = NSNotification.Name("aiwiki.openDashboard")
}
