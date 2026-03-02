import SwiftUI
import UIKit

struct ToolDetailView: View {
    @EnvironmentObject private var store: AppStore

    let tool: AITool
    @State private var copied = false
    private var websiteURL: URL? { URL(string: tool.url) }
    private var learningMaterial: LearningMaterial? { store.learningMaterial(for: tool.id) }

    var body: some View {
        List {
            Section {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(.secondarySystemFill))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(String(tool.name.prefix(1)))
                                .font(.title3)
                                .fontWeight(.semibold)
                        )
                    VStack(alignment: .leading, spacing: 6) {
                        Text(tool.name)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(tool.intro)
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                            .lineLimit(3)
                    }
                }
                .padding(.vertical, 4)
            }

            Section("功能特点") {
                ForEach(tool.features, id: \.self) { feature in
                    Text("• \(feature)")
                }
            }

            if let learningMaterial {
                Section("学习摘要") {
                    Text(learningMaterial.summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if !learningMaterial.coreCapabilities.isEmpty {
                    Section("核心能力") {
                        ForEach(learningMaterial.coreCapabilities, id: \.self) { item in
                            Text("• \(item)")
                        }
                    }
                }

                if !learningMaterial.gettingStarted.isEmpty {
                    Section("快速上手") {
                        ForEach(Array(learningMaterial.gettingStarted.enumerated()), id: \.offset) { index, item in
                            Text("\(index + 1). \(item)")
                        }
                    }
                }

                if !learningMaterial.officialLinks.isEmpty {
                    Section("官方资料") {
                        ForEach(learningMaterial.officialLinks, id: \.self) { link in
                            if let url = URL(string: link) {
                                Link(link, destination: url)
                                    .font(.footnote)
                                    .lineLimit(2)
                            } else {
                                Text(link)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                if !learningMaterial.caveats.isEmpty {
                    Section("注意事项") {
                        ForEach(learningMaterial.caveats, id: \.self) { item in
                            Text("• \(item)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            if let useCases = tool.useCases, !useCases.isEmpty {
                Section("适用场景") {
                    ForEach(useCases, id: \.self) { item in
                        Text("• \(item)")
                    }
                }
            }

            if let bestPractices = tool.bestPractices, !bestPractices.isEmpty {
                Section("最佳实践") {
                    ForEach(bestPractices, id: \.self) { item in
                        Text("• \(item)")
                    }
                }
            }

            if let promptTemplates = tool.promptTemplates, !promptTemplates.isEmpty {
                Section("提示词模板") {
                    ForEach(promptTemplates, id: \.title) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(item.prompt)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .textSelection(.enabled)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }

            Section("基础信息") {
                labeledRow(title: "公司", value: tool.company)
                labeledRow(title: "分类", value: tool.category)
                labeledRow(title: "官网", value: tool.url)
                labeledRow(title: "来源", value: tool.sourceURL)
                labeledRow(title: "最近校验", value: tool.lastVerifiedAt)
                if let learningMaterial {
                    labeledRow(title: "学习资料校验", value: learningMaterial.lastVerifiedAt)
                    labeledRow(title: "学习资料状态", value: learningMaterial.reviewStatus)
                }

                if let access = tool.access {
                    labeledRow(title: "价格", value: access.pricing)
                    labeledRow(title: "是否需账号", value: access.accountRequired ? "是" : "否")
                    labeledRow(title: "支持平台", value: access.platforms.joined(separator: " / "))
                    labeledRow(title: "是否提供 API", value: access.apiAvailable ? "是" : "否")
                }

                if let websiteURL {
                    Link("打开官网", destination: websiteURL)
                }
                Button(copied ? "已复制官网链接" : "复制官网链接") {
                    UIPasteboard.general.string = tool.url
                    copied = true
                }
            }

            Section {
                Button {
                    store.toggleFavorite(tool.id)
                } label: {
                    Label(
                        store.isFavorite(tool.id) ? "取消收藏" : "加入收藏",
                        systemImage: store.isFavorite(tool.id) ? "star.slash" : "star.fill"
                    )
                }
                .foregroundColor(.primary)
            }

            if let strengths = tool.strengths, !strengths.isEmpty {
                Section("优势") {
                    ForEach(strengths, id: \.self) { item in
                        Text("• \(item)")
                    }
                }
            }

            if let limitations = tool.limitations, !limitations.isEmpty {
                Section("局限") {
                    ForEach(limitations, id: \.self) { item in
                        Text("• \(item)")
                    }
                }
            }
        }
        .navigationTitle("详情")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func labeledRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
        }
        .padding(.vertical, 2)
    }
}
