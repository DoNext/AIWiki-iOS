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
        \(L10n.text("outcome.competitor.context.products"))\(productA) vs \(productB)
        \(L10n.text("outcome.competitor.context.window"))\(compareWindow)
        \(L10n.text("outcome.competitor.context.focus"))\(focus)
        \(L10n.text("outcome.competitor.context.audience"))\(audience)
        """
    }

    private var prompt: String {
        L10n.format("outcome.competitor.prompt.body", context)
    }

    private var template: String {
        L10n.text("outcome.competitor.template")
    }

    private var checklist: [String] {
        [
            L10n.text("outcome.competitor.checklist.1"),
            L10n.text("outcome.competitor.checklist.2"),
            L10n.text("outcome.competitor.checklist.3"),
            L10n.text("outcome.competitor.checklist.4")
        ]
    }

    private var refinePrompt: String {
        L10n.text("outcome.competitor.refine")
    }

    private var fullPackage: String {
        """
        [\(L10n.text("outcome.competitor.package.prompt"))]
        \(prompt)

        [\(L10n.text("outcome.competitor.package.template"))]
        \(template)

        [\(L10n.text("outcome.competitor.package.checklist"))]
        \(checklist.map { "- \($0)" }.joined(separator: "\n"))

        [\(L10n.text("outcome.competitor.package.refine"))]
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
