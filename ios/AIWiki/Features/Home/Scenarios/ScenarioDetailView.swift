import SwiftUI
import UIKit

private enum ScenarioViewMode: String, CaseIterable, Identifiable {
    case standard
    case quick

    var id: String { rawValue }

    var title: String {
        switch self {
        case .standard: return "标准模式"
        case .quick: return "1分钟上手"
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

                Picker("查看模式", selection: $mode) {
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
                        store.isScenarioBookmarked(scenario.id) ? "已加入收藏任务" : "保存到收藏任务",
                        systemImage: store.isScenarioBookmarked(scenario.id) ? "bookmark.fill" : "bookmark"
                    )
                }
                .padding(.top, 6)

                if scenario.id == "weekly-report" {
                    NavigationLink {
                        WeeklyReportOutcomeView()
                    } label: {
                        Label("进入一键产出模式", systemImage: "wand.and.stars")
                    }
                    .padding(.top, 4)
                } else if scenario.id == "competitor-brief" {
                    NavigationLink {
                        CompetitorBriefOutcomeView()
                    } label: {
                        Label("进入一键产出模式", systemImage: "wand.and.stars")
                    }
                    .padding(.top, 4)
                } else if scenario.id == "code-debug" {
                    NavigationLink {
                        CodeDebugOutcomeView()
                    } label: {
                        Label("进入一键产出模式", systemImage: "wand.and.stars")
                    }
                    .padding(.top, 4)
                }
            }

            if mode == .quick {
                Section(L10n.format("1分钟上手步骤（%d/%d）", completedCount, scenario.quickStartSteps.count)) {
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
                    Button("重置清单", role: .destructive) {
                        store.resetQuickSteps(scenarioID: scenario.id)
                    }
                }

                if let firstPrompt = scenario.localizedPromptCards.first {
                    Section("先用这个模板") {
                        Text(firstPrompt.prompt)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .textSelection(.enabled)
                        Button("复制模板") {
                            UIPasteboard.general.string = firstPrompt.prompt
                        }
                        .font(.footnote)
                    }
                }

                Section("示例输出") {
                    Text(scenario.localizedExampleOutput)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            } else {
                Section("执行步骤") {
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

                Section("可复制模板") {
                    ForEach(scenario.localizedPromptCards, id: \.title) { card in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(card.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(card.prompt)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .textSelection(.enabled)
                            Button("复制模板") {
                                UIPasteboard.general.string = card.prompt
                            }
                            .font(.footnote)
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("常见坑") {
                    ForEach(scenario.localizedPitfalls, id: \.self) { item in
                        Text("• \(item)")
                    }
                }
            }

            if !relatedTools.isEmpty {
                Section("推荐工具") {
                    ForEach(relatedTools, id: \.id) { tool in
                        NavigationLink {
                            ToolDetailView(tool: tool)
                        } label: {
                            ToolListRow(tool: tool)
                        }
                    }
                }
            }

            Section("复盘问题") {
                ForEach(scenario.localizedReviewQuestions, id: \.self) { item in
                    Text("• \(item)")
                }
            }

            Section("复盘笔记（1-2行）") {
                TextEditor(text: $noteText)
                    .frame(minHeight: 80)
                Button("保存笔记") {
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
