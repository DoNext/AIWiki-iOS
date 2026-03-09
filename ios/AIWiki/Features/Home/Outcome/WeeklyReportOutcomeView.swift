import SwiftUI
import UIKit

struct WeeklyReportOutcomeView: View {
    @State private var audience: String = ""
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

    private var promptForGeneralAI: String {
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

    private var promptForLogicAI: String {
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

    private var promptForCreativeAI: String {
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
        [通用 AI 提示词]
        \(promptForGeneralAI)

        [逻辑提示词]
        \(promptForLogicAI)

        [创意提示词]
        \(promptForCreativeAI)

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
            Section(L10n.text(L10n.Outcome.input)) {
                TextField(L10n.text(L10n.Outcome.audience), text: $audience)
                TextField(L10n.text(L10n.Outcome.highlights), text: $highlights, axis: .vertical)
                    .lineLimit(2...4)
                TextField(L10n.text(L10n.Outcome.metrics), text: $metrics, axis: .vertical)
                    .lineLimit(2...3)
                TextField(L10n.text(L10n.Outcome.risks), text: $risks, axis: .vertical)
                    .lineLimit(2...3)
                TextField(L10n.text(L10n.Outcome.nextPlan), text: $nextPlan, axis: .vertical)
                    .lineLimit(2...3)
            }

            if hasEnoughInput {
                Section(L10n.text(L10n.Outcome.promptsByFunction)) {
                    promptBlock(title: L10n.text(L10n.Outcome.generalAssistant), text: promptForGeneralAI)
                    promptBlock(title: L10n.text(L10n.Outcome.logicEnhanced), text: promptForLogicAI)
                    promptBlock(title: L10n.text(L10n.Outcome.creativeBoost), text: promptForCreativeAI)
                }

                Section(L10n.text(L10n.Outcome.deliverableTemplate)) {
                    copyableText(deliveryTemplate)
                }

                Section(L10n.text(L10n.Outcome.qualityChecklist)) {
                    ForEach(qualityChecklist, id: \.self) { item in
                        Text("• \(item)")
                    }
                }

                Section(L10n.text(L10n.Outcome.refinePrompt)) {
                    copyableText(refinePrompt)
                }

                Section(L10n.text(L10n.Outcome.exportPackage)) {
                    Button(L10n.text(L10n.Outcome.copyFullPackage)) {
                        UIPasteboard.general.string = fullPackage
                    }
                }
            } else {
                Section {
                    Text(L10n.text(L10n.Outcome.weeklyReportEmpty))
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(L10n.text(L10n.Outcome.weeklyReportTitle))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if audience.isEmpty {
                audience = L10n.text(L10n.Outcome.weeklyDefaultAudience)
            }
        }
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
            Button(L10n.text(L10n.Common.copy)) {
                UIPasteboard.general.string = text
            }
            .font(.footnote)
        }
    }
}
