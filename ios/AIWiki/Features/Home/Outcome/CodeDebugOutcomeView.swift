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
        L10n.format(
            "outcome.debug.prompt.body",
            language,
            expectedBehavior.isEmpty ? L10n.text("outcome.debug.value.not_provided") : expectedBehavior,
            errorLog,
            codeSnippet
        )
    }

    private var checklist: [String] {
        [
            L10n.text("outcome.debug.checklist.1"),
            L10n.text("outcome.debug.checklist.2"),
            L10n.text("outcome.debug.checklist.3"),
            L10n.text("outcome.debug.checklist.4")
        ]
    }

    private var refinePrompt: String {
        L10n.text("outcome.debug.refine")
    }

    private var fullPackage: String {
        """
        [\(L10n.text("outcome.debug.package.prompt"))]
        \(prompt)

        [\(L10n.text("outcome.debug.package.checklist"))]
        \(checklist.map { "- \($0)" }.joined(separator: "\n"))

        [\(L10n.text("outcome.debug.package.refine"))]
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
