import SwiftUI
import UIKit

struct CompetitorBriefOutcomeView: View {
    @State private var productA: String = ""
    @State private var productB: String = ""
    @State private var compareWindow: String = ""
    @State private var focus: String = ""
    @State private var audience: String = ""

    private var hasEnoughInput: Bool {
        !productA.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !productB.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var context: String {
        """
        对比对象：\(productA) vs \(productB)
        时间范围：\(compareWindow)
        重点维度：\(focus)
        读者：\(audience)
        """
    }

    private var prompt: String {
        """
        你是资深战略分析师。请基于以下信息生成竞品分析简报：
        \(context)

        输出结构：
        1) 结论摘要（不超过120字）
        2) 功能差异表
        3) 定价与商业模式差异
        4) 目标用户和典型场景
        5) 我方可执行机会（短期/中期）
        6) 风险与假设

        每个关键结论标注来源链接。
        """
    }

    private var template: String {
        """
        【结论摘要】
        ...

        【功能差异】
        - 维度1：A... / B...

        【定价与商业模式】
        - A...
        - B...

        【可执行机会】
        - 短期（2周内）：
        - 中期（1季度）：
        """
    }

    private var checklist: [String] {
        [
            "是否明确时间窗口，避免过期信息",
            "关键结论是否附来源",
            "机会建议是否可执行并有优先级",
            "是否区分事实和推测"
        ]
    }

    private var refinePrompt: String {
        """
        请对上一版竞品简报做二次优化：
        1) 删除重复论述
        2) 强化“可执行动作”与负责人建议
        3) 对每个结论补充来源可信度说明
        """
    }

    private var fullPackage: String {
        """
        [竞品提示词]
        \(prompt)

        [简报模板]
        \(template)

        [质量清单]
        \(checklist.map { "- \($0)" }.joined(separator: "\n"))

        [二次优化]
        \(refinePrompt)
        """
    }

    var body: some View {
        List {
            Section(L10n.text(L10n.Outcome.input)) {
                TextField(L10n.text(L10n.Outcome.productA), text: $productA)
                TextField(L10n.text(L10n.Outcome.productB), text: $productB)
                TextField(L10n.text(L10n.Outcome.timeRange), text: $compareWindow)
                TextField(L10n.text(L10n.Outcome.focus), text: $focus, axis: .vertical)
                    .lineLimit(2...3)
                TextField(L10n.text(L10n.Outcome.audience), text: $audience)
            }

            if hasEnoughInput {
                Section(L10n.text(L10n.Outcome.prompt)) {
                    copyable(prompt)
                }
                Section(L10n.text(L10n.Outcome.deliverableTemplate)) {
                    copyable(template)
                }
                Section(L10n.text(L10n.Outcome.qualityChecklist)) {
                    ForEach(checklist, id: \.self) { item in
                        Text("• \(item)")
                    }
                }
                Section(L10n.text(L10n.Outcome.refinePrompt)) {
                    copyable(refinePrompt)
                }
                Section(L10n.text(L10n.Outcome.exportPackage)) {
                    Button(L10n.text(L10n.Outcome.copyFullPackage)) {
                        UIPasteboard.general.string = fullPackage
                    }
                }
            } else {
                Section {
                    Text(L10n.text(L10n.Outcome.competitorEmpty))
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(L10n.text(L10n.Outcome.competitorTitle))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if compareWindow.isEmpty { compareWindow = L10n.text(L10n.Outcome.competitorDefaultWindow) }
            if focus.isEmpty { focus = L10n.text(L10n.Outcome.competitorDefaultFocus) }
            if audience.isEmpty { audience = L10n.text(L10n.Outcome.competitorDefaultAudience) }
        }
    }

    private func copyable(_ text: String) -> some View {
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
