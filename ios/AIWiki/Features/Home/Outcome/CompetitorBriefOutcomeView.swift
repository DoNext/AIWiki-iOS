import SwiftUI
import UIKit

struct CompetitorBriefOutcomeView: View {
    @State private var productA: String = ""
    @State private var productB: String = ""
    @State private var compareWindow: String = "近12个月"
    @State private var focus: String = "功能、定价、目标用户、增长策略"
    @State private var audience: String = "产品团队"

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
            Section("输入信息") {
                TextField("产品A（必填）", text: $productA)
                TextField("产品B（必填）", text: $productB)
                TextField("时间范围", text: $compareWindow)
                TextField("重点维度", text: $focus, axis: .vertical)
                    .lineLimit(2...3)
                TextField("读者对象", text: $audience)
            }

            if hasEnoughInput {
                Section("一键提示词") {
                    copyable(prompt)
                }
                Section("可交付模板") {
                    copyable(template)
                }
                Section("质量检查清单") {
                    ForEach(checklist, id: \.self) { item in
                        Text("• \(item)")
                    }
                }
                Section("二次优化提示词") {
                    copyable(refinePrompt)
                }
                Section("导出结果包") {
                    Button("一键复制完整结果包") {
                        UIPasteboard.general.string = fullPackage
                    }
                }
            } else {
                Section {
                    Text("先填写产品A和产品B。")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("一键产出：竞品简报")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func copyable(_ text: String) -> some View {
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
