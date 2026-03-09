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
        \(L10n.text("outcome.weekly.context.audience"))\(audience)
        \(L10n.text("outcome.weekly.context.highlights"))\(highlights)
        \(L10n.text("outcome.weekly.context.metrics"))\(metrics.isEmpty ? L10n.text("outcome.weekly.value.none") : metrics)
        \(L10n.text("outcome.weekly.context.risks"))\(risks.isEmpty ? L10n.text("outcome.weekly.value.none") : risks)
        \(L10n.text("outcome.weekly.context.next_plan"))\(nextPlan.isEmpty ? L10n.text("outcome.weekly.value.todo") : nextPlan)
        """
    }

    private var promptForGeneralAI: String {
        L10n.format("outcome.weekly.prompt.general", contextBlock)
    }

    private var promptForLogicAI: String {
        L10n.format("outcome.weekly.prompt.logic", contextBlock)
    }

    private var promptForCreativeAI: String {
        L10n.format("outcome.weekly.prompt.creative", contextBlock)
    }

    private var deliveryTemplate: String {
        L10n.text("outcome.weekly.template")
    }

    private var qualityChecklist: [String] {
        [
            L10n.text("outcome.weekly.checklist.1"),
            L10n.text("outcome.weekly.checklist.2"),
            L10n.text("outcome.weekly.checklist.3"),
            L10n.text("outcome.weekly.checklist.4"),
            L10n.text("outcome.weekly.checklist.5")
        ]
    }

    private var refinePrompt: String {
        L10n.text("outcome.weekly.refine")
    }

    private var fullPackage: String {
        """
        [\(L10n.text("outcome.weekly.package.general_prompt"))]
        \(promptForGeneralAI)

        [\(L10n.text("outcome.weekly.package.logic_prompt"))]
        \(promptForLogicAI)

        [\(L10n.text("outcome.weekly.package.creative_prompt"))]
        \(promptForCreativeAI)

        [\(L10n.text("outcome.weekly.package.template"))]
        \(deliveryTemplate)

        [\(L10n.text("outcome.weekly.package.checklist"))]
        \(qualityChecklist.map { "- \($0)" }.joined(separator: "\n"))

        [\(L10n.text("outcome.weekly.package.refine_prompt"))]
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
