import Foundation

enum ScenarioLibrary {
    static let all: [TaskScenario] = [
        TaskScenario(
            id: "weekly-report",
            title: "scenario.weekly_report.title",
            subtitle: "scenario.weekly_report.subtitle",
            outcome: "scenario.weekly_report.outcome",
            quickStartSteps: [
                "scenario.weekly_report.quick_step_1",
                "scenario.weekly_report.quick_step_2",
                "scenario.weekly_report.quick_step_3"
            ],
            steps: [
                .init(title: "scenario.weekly_report.step_1.title", detail: "scenario.weekly_report.step_1.detail"),
                .init(title: "scenario.weekly_report.step_2.title", detail: "scenario.weekly_report.step_2.detail"),
                .init(title: "scenario.weekly_report.step_3.title", detail: "scenario.weekly_report.step_3.detail")
            ],
            promptCards: [
                .init(
                    title: "scenario.weekly_report.prompt_1.title",
                    prompt: "scenario.weekly_report.prompt_1.body"
                )
            ],
            pitfalls: ["scenario.weekly_report.pitfall_1", "scenario.weekly_report.pitfall_2"],
            exampleOutput: "scenario.weekly_report.example_output",
            reviewQuestions: ["scenario.weekly_report.review_1", "scenario.weekly_report.review_2"],
            relatedToolIDs: ["deepseek", "claude", "gemini"]
        ),
        TaskScenario(
            id: "competitor-brief",
            title: "scenario.competitor_brief.title",
            subtitle: "scenario.competitor_brief.subtitle",
            outcome: "scenario.competitor_brief.outcome",
            quickStartSteps: [
                "scenario.competitor_brief.quick_step_1",
                "scenario.competitor_brief.quick_step_2",
                "scenario.competitor_brief.quick_step_3"
            ],
            steps: [
                .init(title: "scenario.competitor_brief.step_1.title", detail: "scenario.competitor_brief.step_1.detail"),
                .init(title: "scenario.competitor_brief.step_2.title", detail: "scenario.competitor_brief.step_2.detail"),
                .init(title: "scenario.competitor_brief.step_3.title", detail: "scenario.competitor_brief.step_3.detail")
            ],
            promptCards: [
                .init(
                    title: "scenario.competitor_brief.prompt_1.title",
                    prompt: "scenario.competitor_brief.prompt_1.body"
                )
            ],
            pitfalls: ["scenario.competitor_brief.pitfall_1", "scenario.competitor_brief.pitfall_2"],
            exampleOutput: "scenario.competitor_brief.example_output",
            reviewQuestions: ["scenario.competitor_brief.review_1", "scenario.competitor_brief.review_2"],
            relatedToolIDs: ["perplexity", "notebooklm", "deepseek"]
        ),
        TaskScenario(
            id: "code-debug",
            title: "scenario.code_debug.title",
            subtitle: "scenario.code_debug.subtitle",
            outcome: "scenario.code_debug.outcome",
            quickStartSteps: [
                "scenario.code_debug.quick_step_1",
                "scenario.code_debug.quick_step_2",
                "scenario.code_debug.quick_step_3"
            ],
            steps: [
                .init(title: "scenario.code_debug.step_1.title", detail: "scenario.code_debug.step_1.detail"),
                .init(title: "scenario.code_debug.step_2.title", detail: "scenario.code_debug.step_2.detail"),
                .init(title: "scenario.code_debug.step_3.title", detail: "scenario.code_debug.step_3.detail")
            ],
            promptCards: [
                .init(
                    title: "scenario.code_debug.prompt_1.title",
                    prompt: "scenario.code_debug.prompt_1.body"
                )
            ],
            pitfalls: ["scenario.code_debug.pitfall_1", "scenario.code_debug.pitfall_2"],
            exampleOutput: "scenario.code_debug.example_output",
            reviewQuestions: ["scenario.code_debug.review_1", "scenario.code_debug.review_2"],
            relatedToolIDs: ["github-copilot", "cursor", "deepseek"]
        ),
        TaskScenario(
            id: "study-plan",
            title: "scenario.study_plan.title",
            subtitle: "scenario.study_plan.subtitle",
            outcome: "scenario.study_plan.outcome",
            quickStartSteps: [
                "scenario.study_plan.quick_step_1",
                "scenario.study_plan.quick_step_2",
                "scenario.study_plan.quick_step_3"
            ],
            steps: [
                .init(title: "scenario.study_plan.step_1.title", detail: "scenario.study_plan.step_1.detail"),
                .init(title: "scenario.study_plan.step_2.title", detail: "scenario.study_plan.step_2.detail"),
                .init(title: "scenario.study_plan.step_3.title", detail: "scenario.study_plan.step_3.detail")
            ],
            promptCards: [
                .init(
                    title: "scenario.study_plan.prompt_1.title",
                    prompt: "scenario.study_plan.prompt_1.body"
                )
            ],
            pitfalls: ["scenario.study_plan.pitfall_1", "scenario.study_plan.pitfall_2"],
            exampleOutput: "scenario.study_plan.example_output",
            reviewQuestions: ["scenario.study_plan.review_1", "scenario.study_plan.review_2"],
            relatedToolIDs: ["gemini", "notebooklm", "claude"]
        ),
        TaskScenario(
            id: "content-creation",
            title: "scenario.content_creation.title",
            subtitle: "scenario.content_creation.subtitle",
            outcome: "scenario.content_creation.outcome",
            quickStartSteps: [
                "scenario.content_creation.quick_step_1",
                "scenario.content_creation.quick_step_2",
                "scenario.content_creation.quick_step_3"
            ],
            steps: [
                .init(title: "scenario.content_creation.step_1.title", detail: "scenario.content_creation.step_1.detail"),
                .init(title: "scenario.content_creation.step_2.title", detail: "scenario.content_creation.step_2.detail"),
                .init(title: "scenario.content_creation.step_3.title", detail: "scenario.content_creation.step_3.detail")
            ],
            promptCards: [
                .init(
                    title: "scenario.content_creation.prompt_1.title",
                    prompt: "scenario.content_creation.prompt_1.body"
                )
            ],
            pitfalls: ["scenario.content_creation.pitfall_1", "scenario.content_creation.pitfall_2"],
            exampleOutput: "scenario.content_creation.example_output",
            reviewQuestions: ["scenario.content_creation.review_1", "scenario.content_creation.review_2"],
            relatedToolIDs: ["deepseek", "jasper", "notion-ai"]
        ),
        TaskScenario(
            id: "meeting-summary",
            title: "scenario.meeting_summary.title",
            subtitle: "scenario.meeting_summary.subtitle",
            outcome: "scenario.meeting_summary.outcome",
            quickStartSteps: [
                "scenario.meeting_summary.quick_step_1",
                "scenario.meeting_summary.quick_step_2",
                "scenario.meeting_summary.quick_step_3"
            ],
            steps: [
                .init(title: "scenario.meeting_summary.step_1.title", detail: "scenario.meeting_summary.step_1.detail"),
                .init(title: "scenario.meeting_summary.step_2.title", detail: "scenario.meeting_summary.step_2.detail"),
                .init(title: "scenario.meeting_summary.step_3.title", detail: "scenario.meeting_summary.step_3.detail")
            ],
            promptCards: [
                .init(
                    title: "scenario.meeting_summary.prompt_1.title",
                    prompt: "scenario.meeting_summary.prompt_1.body"
                )
            ],
            pitfalls: ["scenario.meeting_summary.pitfall_1", "scenario.meeting_summary.pitfall_2"],
            exampleOutput: "scenario.meeting_summary.example_output",
            reviewQuestions: ["scenario.meeting_summary.review_1", "scenario.meeting_summary.review_2"],
            relatedToolIDs: ["whisper", "otter-ai", "deepseek"]
        ),
        TaskScenario(
            id: "data-report",
            title: "scenario.data_report.title",
            subtitle: "scenario.data_report.subtitle",
            outcome: "scenario.data_report.outcome",
            quickStartSteps: [
                "scenario.data_report.quick_step_1",
                "scenario.data_report.quick_step_2",
                "scenario.data_report.quick_step_3"
            ],
            steps: [
                .init(title: "scenario.data_report.step_1.title", detail: "scenario.data_report.step_1.detail"),
                .init(title: "scenario.data_report.step_2.title", detail: "scenario.data_report.step_2.detail"),
                .init(title: "scenario.data_report.step_3.title", detail: "scenario.data_report.step_3.detail")
            ],
            promptCards: [
                .init(
                    title: "scenario.data_report.prompt_1.title",
                    prompt: "scenario.data_report.prompt_1.body"
                )
            ],
            pitfalls: ["scenario.data_report.pitfall_1", "scenario.data_report.pitfall_2"],
            exampleOutput: "scenario.data_report.example_output",
            reviewQuestions: ["scenario.data_report.review_1", "scenario.data_report.review_2"],
            relatedToolIDs: ["julius-ai", "deepseek", "notebooklm"]
        ),
        TaskScenario(
            id: "email-writing",
            title: "scenario.email_writing.title",
            subtitle: "scenario.email_writing.subtitle",
            outcome: "scenario.email_writing.outcome",
            quickStartSteps: [
                "scenario.email_writing.quick_step_1",
                "scenario.email_writing.quick_step_2",
                "scenario.email_writing.quick_step_3"
            ],
            steps: [
                .init(title: "scenario.email_writing.step_1.title", detail: "scenario.email_writing.step_1.detail"),
                .init(title: "scenario.email_writing.step_2.title", detail: "scenario.email_writing.step_2.detail"),
                .init(title: "scenario.email_writing.step_3.title", detail: "scenario.email_writing.step_3.detail")
            ],
            promptCards: [
                .init(
                    title: "scenario.email_writing.prompt_1.title",
                    prompt: "scenario.email_writing.prompt_1.body"
                )
            ],
            pitfalls: ["scenario.email_writing.pitfall_1", "scenario.email_writing.pitfall_2"],
            exampleOutput: "scenario.email_writing.example_output",
            reviewQuestions: ["scenario.email_writing.review_1", "scenario.email_writing.review_2"],
            relatedToolIDs: ["grammarly", "deepseek", "claude"]
        )
    ]
}
