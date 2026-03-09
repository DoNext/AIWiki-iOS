import SwiftUI
import UIKit

private enum ScenarioViewMode: String, CaseIterable, Identifiable {
    case standard
    case quick

    var id: String { rawValue }

    var title: String {
        switch self {
        case .standard: return L10n.text(L10n.Scenario.standard)
        case .quick: return L10n.text(L10n.Scenario.quick)
        }
    }
}

struct ScenarioDetailView: View {
    @EnvironmentObject private var store: AppStore
    @State private var mode: ScenarioViewMode = .quick
    @State private var noteText: String = ""

    let scenario: TaskScenario

    var relatedTools: [AITool] {
        scenario.relatedToolIDs.compactMap { store.tool(withID: $0) }
    }

    private var completedCount: Int {
        store.completedQuickStepCount(scenarioID: scenario.id)
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(scenario.localizedSubtitle)
                        .font(.headline)
                    Text(scenario.localizedOutcome)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)

                Picker(L10n.text(L10n.Scenario.viewMode), selection: $mode) {
                    ForEach(ScenarioViewMode.allCases) { item in
                        Text(item.title).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 6)

                Button {
                    store.toggleScenarioBookmark(scenario.id)
                } label: {
                    Label(
                        store.isScenarioBookmarked(scenario.id) ? L10n.text(L10n.Scenario.bookmarked) : L10n.text(L10n.Scenario.saveTask),
                        systemImage: store.isScenarioBookmarked(scenario.id) ? "bookmark.fill" : "bookmark"
                    )
                }
                .padding(.top, 6)

                if scenario.id == "weekly-report" {
                    NavigationLink {
                        WeeklyReportOutcomeView()
                    } label: {
                        Label(L10n.text(L10n.Scenario.openOutput), systemImage: "wand.and.stars")
                    }
                    .padding(.top, 4)
                } else if scenario.id == "competitor-brief" {
                    NavigationLink {
                        CompetitorBriefOutcomeView()
                    } label: {
                        Label(L10n.text(L10n.Scenario.openOutput), systemImage: "wand.and.stars")
                    }
                    .padding(.top, 4)
                } else if scenario.id == "code-debug" {
                    NavigationLink {
                        CodeDebugOutcomeView()
                    } label: {
                        Label(L10n.text(L10n.Scenario.openOutput), systemImage: "wand.and.stars")
                    }
                    .padding(.top, 4)
                }
            }

            if mode == .quick {
                Section(L10n.format(L10n.Scenario.quickSteps, completedCount, scenario.quickStartSteps.count)) {
                    ForEach(Array(scenario.localizedQuickStartSteps.enumerated()), id: \.offset) { index, step in
                        Button {
                            store.toggleQuickStepCompleted(scenarioID: scenario.id, stepIndex: index)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: store.isQuickStepCompleted(scenarioID: scenario.id, stepIndex: index) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(store.isQuickStepCompleted(scenarioID: scenario.id, stepIndex: index) ? .green : .secondary)
                                Text("\(index + 1). \(step)")
                                    .foregroundColor(.primary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    Button(L10n.text(L10n.Scenario.reset), role: .destructive) {
                        store.resetQuickSteps(scenarioID: scenario.id)
                    }
                }

                if let firstPrompt = scenario.localizedPromptCards.first {
                    Section(L10n.text(L10n.Scenario.starterTemplate)) {
                        Text(firstPrompt.prompt)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .textSelection(.enabled)
                        Button(L10n.text(L10n.Scenario.copyTemplate)) {
                            UIPasteboard.general.string = firstPrompt.prompt
                        }
                        .font(.footnote)
                    }
                }

                Section(L10n.text(L10n.Scenario.exampleOutput)) {
                    Text(scenario.localizedExampleOutput)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            } else {
                Section(L10n.text(L10n.Scenario.steps)) {
                    ForEach(Array(scenario.localizedSteps.enumerated()), id: \.offset) { index, step in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(index + 1). \(step.title)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(step.detail)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                }

                Section(L10n.text(L10n.Scenario.templates)) {
                    ForEach(scenario.localizedPromptCards, id: \.title) { card in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(card.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(card.prompt)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .textSelection(.enabled)
                            Button(L10n.text(L10n.Scenario.copyTemplate)) {
                                UIPasteboard.general.string = card.prompt
                            }
                            .font(.footnote)
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section(L10n.text(L10n.Scenario.pitfalls)) {
                    ForEach(scenario.localizedPitfalls, id: \.self) { item in
                        Text("• \(item)")
                    }
                }
            }

            if !relatedTools.isEmpty {
                Section(L10n.text(L10n.Scenario.recommendedTools)) {
                    ForEach(relatedTools, id: \.id) { tool in
                        NavigationLink {
                            ToolDetailView(tool: tool)
                        } label: {
                            ToolListRow(tool: tool)
                        }
                    }
                }
            }

            Section(L10n.text(L10n.Scenario.reviewQuestions)) {
                ForEach(scenario.localizedReviewQuestions, id: \.self) { item in
                    Text("• \(item)")
                }
            }

            Section(L10n.text(L10n.Scenario.reviewNotes)) {
                TextEditor(text: $noteText)
                    .frame(minHeight: 80)
                Button(L10n.text(L10n.Scenario.saveNote)) {
                    store.updateNote(for: scenario.id, text: noteText.trimmingCharacters(in: .whitespacesAndNewlines))
                }
                .disabled(noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .navigationTitle(scenario.localizedTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            noteText = store.note(for: scenario.id)
        }
    }
}
