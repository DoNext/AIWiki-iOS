import SwiftUI
import UIKit

struct WeeklyReportOutcomeView: View {
    @State private var audience: String = "产品与研发团队"
    @State private var highlights: String = ""
    @State private var metrics: String = ""
    @State private var risks: String = ""
    @State private var nextPlan: String = ""

    private var hasEnoughInput: Bool {
        !highlights.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var contextBlock: String {
        """
        读者：\(audience)
        本周完成事项：\(highlights)
        关键数据：\(metrics.isEmpty ? "暂无" : metrics)
        风险/阻塞：\(risks.isEmpty ? "暂无" : risks)
        下周计划：\(nextPlan.isEmpty ? "待补充" : nextPlan)
        """
    }

    private var promptForChatGPT: String {
        """
        你是团队负责人助理。请根据以下信息生成可直接发送的中文周报：
        \(contextBlock)

        输出格式固定：
        1) 本周完成（3-5条）
        2) 关键数据（含变化趋势）
        3) 风险与阻塞（含影响和缓解动作）
        4) 下周计划（按优先级）
        5) 需要协同事项（按负责人）

        要求：结论先行，语言简洁，不要空话。
        """
    }

    private var promptForClaude: String {
        """
        你是严谨的项目管理助理。基于以下输入生成周报，并额外指出“信息缺口”：
        \(contextBlock)

        返回结构：
        A. 管理层 120 字摘要
        B. 本周完成（项目符号）
        C. 风险与建议动作
        D. 下周计划
        E. 信息缺口（如缺负责人/缺数据）
        """
    }

    private var promptForGemini: String {
        """
        请把以下周工作信息整理成“可对外同步”的周报：
        \(contextBlock)

        输出要求：
        - 先给 3 行摘要
        - 再给完整周报
        - 最后给一个“30秒口头汇报版本”
        """
    }

    private var deliveryTemplate: String {
        """
        【本周完成】
        - ...

        【关键数据】
        - 指标A：本周 X（上周 Y，环比 ...）

        【风险与阻塞】
        - 问题：...
        - 影响：...
        - 缓解动作：...

        【下周计划】
        - P0：...
        - P1：...

        【需要协同】
        - 事项：...｜Owner：...｜截止：...
        """
    }

    private var qualityChecklist: [String] {
        [
            "是否写清“结果”而不是只写“过程”",
            "关键数据是否带对比（上周/目标）",
            "风险项是否给出影响和动作",
            "下周计划是否有优先级和负责人",
            "全文是否能在 1 分钟内读完核心信息"
        ]
    }

    private var refinePrompt: String {
        """
        请基于上一版周报做二次优化：
        1) 删掉空话和重复表达
        2) 把风险与动作写得更具体
        3) 将下周计划按 P0/P1 排序并补 owner
        4) 最终控制在 450 字内
        """
    }

    private var fullPackage: String {
        """
        [ChatGPT 提示词]
        \(promptForChatGPT)

        [Claude 提示词]
        \(promptForClaude)

        [Gemini 提示词]
        \(promptForGemini)

        [可交付模板]
        \(deliveryTemplate)

        [质量检查清单]
        \(qualityChecklist.map { "- \($0)" }.joined(separator: "\n"))

        [二次优化提示词]
        \(refinePrompt)
        """
    }

    var body: some View {
        List {
            Section("输入信息") {
                TextField("读者对象", text: $audience)
                TextField("本周完成事项（必填）", text: $highlights, axis: .vertical)
                    .lineLimit(2...4)
                TextField("关键数据（可选）", text: $metrics, axis: .vertical)
                    .lineLimit(2...3)
                TextField("风险/阻塞（可选）", text: $risks, axis: .vertical)
                    .lineLimit(2...3)
                TextField("下周计划（可选）", text: $nextPlan, axis: .vertical)
                    .lineLimit(2...3)
            }

            if hasEnoughInput {
                Section("一键提示词（按工具）") {
                    promptBlock(title: "ChatGPT", text: promptForChatGPT)
                    promptBlock(title: "Claude", text: promptForClaude)
                    promptBlock(title: "Gemini", text: promptForGemini)
                }

                Section("可交付模板") {
                    copyableText(deliveryTemplate)
                }

                Section("质量检查清单") {
                    ForEach(qualityChecklist, id: \.self) { item in
                        Text("• \(item)")
                    }
                }

                Section("二次优化提示词") {
                    copyableText(refinePrompt)
                }

                Section("导出结果包") {
                    Button("一键复制完整结果包") {
                        UIPasteboard.general.string = fullPackage
                    }
                }
            } else {
                Section {
                    Text("先填写“本周完成事项”，即可生成可复制结果。")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("一键产出：周报")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func promptBlock(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
            copyableText(text)
        }
        .padding(.vertical, 4)
    }

    private func copyableText(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(text)
                .font(.footnote)
                .foregroundColor(.secondary)
                .textSelection(.enabled)
            Button("复制") {
                UIPasteboard.general.string = text
            }
            .font(.footnote)
        }
    }
}
