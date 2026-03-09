import SwiftUI
import UIKit

struct CodeDebugOutcomeView: View {
    @State private var language: String = "Swift"
    @State private var expectedBehavior: String = ""
    @State private var errorLog: String = ""
    @State private var codeSnippet: String = ""

    private var hasEnoughInput: Bool {
        !errorLog.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !codeSnippet.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var prompt: String {
        """
        你是资深 \(language) 工程师。请定位并修复以下问题。

        预期行为：
        \(expectedBehavior.isEmpty ? "未提供" : expectedBehavior)

        报错日志：
        \(errorLog)

        代码片段：
        \(codeSnippet)

        请按以下格式输出：
        A. 根因分析
        B. 最小修复方案
        C. 修复后代码
        D. 回归测试清单
        E. 防止复发建议
        """
    }

    private var checklist: [String] {
        [
            "根因是否与日志一致",
            "修复是否为最小改动",
            "是否覆盖边界测试",
            "是否评估副作用"
        ]
    }

    private var refinePrompt: String {
        """
        请基于上一版修复结果进行二次审查：
        1) 找出潜在副作用
        2) 提供更稳健但复杂度可控的备选方案
        3) 补充缺失测试用例
        """
    }

    private var fullPackage: String {
        """
        [排错提示词]
        \(prompt)

        [质量清单]
        \(checklist.map { "- \($0)" }.joined(separator: "\n"))

        [二次优化]
        \(refinePrompt)
        """
    }

    var body: some View {
        List {
            Section(L10n.text(L10n.Outcome.input)) {
                TextField(L10n.text(L10n.Outcome.language), text: $language)
                TextField(L10n.text(L10n.Outcome.expectedBehavior), text: $expectedBehavior, axis: .vertical)
                    .lineLimit(2...3)
                TextField(L10n.text(L10n.Outcome.errorLog), text: $errorLog, axis: .vertical)
                    .lineLimit(4...8)
                TextField(L10n.text(L10n.Outcome.codeSnippet), text: $codeSnippet, axis: .vertical)
                    .lineLimit(6...12)
            }

            if hasEnoughInput {
                Section(L10n.text(L10n.Outcome.prompt)) {
                    copyable(prompt)
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
                    Text(L10n.text(L10n.Outcome.debugEmpty))
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(L10n.text(L10n.Outcome.debugTitle))
        .navigationBarTitleDisplayMode(.inline)
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
