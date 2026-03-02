import SwiftUI
import UIKit

struct ToolDetailView: View {
    @EnvironmentObject private var store: AppStore

    let tool: AITool
    @State private var copied = false
    private var websiteURL: URL? { URL(string: tool.url) }
    private var learningMaterial: LearningMaterial? { store.learningMaterial(for: tool.id) }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Header
                VStack(spacing: 14) {
                    ToolAvatar(name: tool.name, size: 80)

                    Text(tool.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.textPrimary)

                    Text(tool.company)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)

                    // Favorite button
                    Button {
                        store.toggleFavorite(tool.id)
                    } label: {
                        Label(
                            store.isFavorite(tool.id) ? "已收藏" : "收藏",
                            systemImage: store.isFavorite(tool.id) ? "heart.fill" : "heart"
                        )
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(store.isFavorite(tool.id) ? .white : AppColors.accent)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(store.isFavorite(tool.id) ? AppColors.accent : AppColors.card)
                        )
                        .overlay(
                            Capsule()
                                .stroke(AppColors.accent.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)

                // MARK: - Intro
                detailSection("简介") {
                    Text(tool.intro)
                        .font(.body)
                        .foregroundColor(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // MARK: - Features
                detailSection("功能特点") {
                    FlowLayout(spacing: 8) {
                        ForEach(tool.features, id: \.self) { feature in
                            Text(feature)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.accentLight)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(AppColors.accent.opacity(0.15))
                                )
                        }
                    }
                }

                // MARK: - Learning Material
                if let learningMaterial {
                    detailSection("学习摘要") {
                        Text(learningMaterial.summary)
                            .font(.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    if !learningMaterial.coreCapabilities.isEmpty {
                        detailSection("核心能力") {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(learningMaterial.coreCapabilities, id: \.self) { item in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(AppColors.accent)
                                            .font(.caption)
                                        Text(item)
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.textPrimary)
                                    }
                                }
                            }
                        }
                    }

                    if !learningMaterial.gettingStarted.isEmpty {
                        detailSection("快速上手") {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(learningMaterial.gettingStarted.enumerated()), id: \.offset) { index, item in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("\(index + 1)")
                                            .font(.caption.weight(.bold))
                                            .foregroundColor(AppColors.accent)
                                            .frame(width: 20, height: 20)
                                            .background(Circle().fill(AppColors.accent.opacity(0.15)))
                                        Text(item)
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.textPrimary)
                                    }
                                }
                            }
                        }
                    }

                    if !learningMaterial.officialLinks.isEmpty {
                        detailSection("官方资料") {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(learningMaterial.officialLinks, id: \.self) { link in
                                    if let url = URL(string: link) {
                                        Link(link, destination: url)
                                            .font(.footnote)
                                            .foregroundColor(AppColors.accentLight)
                                            .lineLimit(2)
                                    }
                                }
                            }
                        }
                    }

                    if !learningMaterial.caveats.isEmpty {
                        detailSection("注意事项") {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(learningMaterial.caveats, id: \.self) { item in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.orange)
                                            .font(.caption2)
                                        Text(item)
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                }
                            }
                        }
                    }
                }

                // MARK: - Use Cases
                if let useCases = tool.useCases, !useCases.isEmpty {
                    detailSection("适用场景") {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(useCases, id: \.self) { item in
                                bulletRow(item)
                            }
                        }
                    }
                }

                // MARK: - Best Practices
                if let bestPractices = tool.bestPractices, !bestPractices.isEmpty {
                    detailSection("最佳实践") {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(bestPractices, id: \.self) { item in
                                bulletRow(item)
                            }
                        }
                    }
                }

                // MARK: - Prompt Templates
                if let promptTemplates = tool.promptTemplates, !promptTemplates.isEmpty {
                    detailSection("提示词模板") {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(promptTemplates, id: \.title) { item in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(AppColors.textPrimary)
                                    Text(item.prompt)
                                        .font(.footnote)
                                        .foregroundColor(AppColors.textSecondary)
                                        .textSelection(.enabled)
                                }
                            }
                        }
                    }
                }

                // MARK: - Strengths & Limitations
                if let strengths = tool.strengths, !strengths.isEmpty {
                    detailSection("优势") {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(strengths, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    Text(item)
                                        .font(.subheadline)
                                        .foregroundColor(AppColors.textPrimary)
                                }
                            }
                        }
                    }
                }

                if let limitations = tool.limitations, !limitations.isEmpty {
                    detailSection("局限") {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(limitations, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.orange)
                                        .font(.caption)
                                    Text(item)
                                        .font(.subheadline)
                                        .foregroundColor(AppColors.textPrimary)
                                }
                            }
                        }
                    }
                }

                // MARK: - Info & Actions
                detailSection("基础信息") {
                    VStack(alignment: .leading, spacing: 10) {
                        infoRow(label: "公司", value: tool.company)
                        infoRow(label: "分类", value: tool.category)

                        if let access = tool.access {
                            infoRow(label: "价格", value: access.pricing)
                            infoRow(label: "需要账号", value: access.accountRequired ? "是" : "否")
                            infoRow(label: "平台", value: access.platforms.joined(separator: " / "))
                            infoRow(label: "API", value: access.apiAvailable ? "是" : "否")
                        }
                    }
                }

                // Action buttons
                VStack(spacing: 10) {
                    if let websiteURL {
                        Link(destination: websiteURL) {
                            HStack {
                                Image(systemName: "safari")
                                Text("打开官网")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppGradients.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }

                    Button {
                        UIPasteboard.general.string = tool.url
                        copied = true
                    } label: {
                        HStack {
                            Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            Text(copied ? "已复制" : "复制官网链接")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(AppColors.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(AppColors.accent.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("详情")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helpers

    private func detailSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .cardStyle()
    }

    private func bulletRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(AppColors.accent)
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            Text(text)
                .font(.subheadline)
                .foregroundColor(AppColors.textPrimary)
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(AppColors.textPrimary)
        }
    }
}

// MARK: - Flow Layout (for feature pills)
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, origin) in result.origins.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + origin.x, y: bounds.minY + origin.y), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, origins: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var origins: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            origins.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), origins)
    }
}
