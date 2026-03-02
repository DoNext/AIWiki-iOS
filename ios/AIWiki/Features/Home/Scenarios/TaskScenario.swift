import Foundation

struct TaskScenario: Identifiable, Hashable {
    struct WorkflowStep: Hashable {
        let title: String
        let detail: String
    }

    struct PromptCard: Hashable {
        let title: String
        let prompt: String
    }

    let id: String
    let title: String
    let subtitle: String
    let outcome: String
    let quickStartSteps: [String]
    let steps: [WorkflowStep]
    let promptCards: [PromptCard]
    let pitfalls: [String]
    let exampleOutput: String
    let reviewQuestions: [String]
    let relatedToolIDs: [String]
}
