import Foundation
@testable import AIWiki

struct MockToolRepository: ToolRepository {
    let tools: [AITool]

    func fetchAll() throws -> [AITool] {
        tools
    }
}

enum Fixture {
    static let tools: [AITool] = [
        AITool(
            id: "deepseek",
            name: "DeepSeek",
            intro: "高性能开源大语言模型",
            features: ["自然语言问答", "代码生成", "多轮对话"],
            company: "DeepSeek",
            url: "https://www.deepseek.com/",
            icon: "deepseek.png",
            category: "聊天机器人",
            sourceURL: "https://www.deepseek.com/",
            lastVerifiedAt: "2026-03-02",
            useCases: nil,
            bestPractices: nil,
            strengths: nil,
            limitations: nil,
            promptTemplates: nil,
            access: nil,
            radarScores: nil
        ),
        AITool(
            id: "copilot",
            name: "GitHub Copilot",
            intro: "面向开发者的 AI 编程助手",
            features: ["代码补全", "聊天问答"],
            company: "GitHub",
            url: "https://github.com/features/copilot",
            icon: "copilot.png",
            category: "编程助手",
            sourceURL: "https://github.com/features/copilot",
            lastVerifiedAt: "2026-03-02",
            useCases: nil,
            bestPractices: nil,
            strengths: nil,
            limitations: nil,
            promptTemplates: nil,
            access: nil,
            radarScores: nil
        )
    ]
}
