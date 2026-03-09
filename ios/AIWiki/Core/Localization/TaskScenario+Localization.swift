import Foundation

extension TaskScenario {
    var localizedTitle: String { L10n.text(title) }
    var localizedSubtitle: String { L10n.text(subtitle) }
    var localizedOutcome: String { L10n.text(outcome) }
    var localizedQuickStartSteps: [String] { quickStartSteps.map(L10n.text) }
    var localizedPitfalls: [String] { pitfalls.map(L10n.text) }
    var localizedExampleOutput: String { L10n.text(exampleOutput) }
    var localizedReviewQuestions: [String] { reviewQuestions.map(L10n.text) }
    var localizedSteps: [WorkflowStep] {
        steps.map { .init(title: L10n.text($0.title), detail: L10n.text($0.detail)) }
    }
    var localizedPromptCards: [PromptCard] {
        promptCards.map { .init(title: L10n.text($0.title), prompt: L10n.text($0.prompt)) }
    }
}
