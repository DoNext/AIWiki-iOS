import SwiftUI
import UIKit
import Charts

struct CompareView: View {
    @EnvironmentObject private var store: AppStore
    @State private var toolA: AITool?
    @State private var toolB: AITool?
    @State private var showingPickerForSlot: PickerSlot?
    @State private var sharedImage: UIImage?
    @State private var isSharing = false

    enum PickerSlot: Identifiable {
        case a, b
        var id: Self { self }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Selection header
                HStack(spacing: 12) {
                    slotButton(tool: toolA, label: "工具 A") {
                        showingPickerForSlot = .a
                    }

                    Image(systemName: "arrow.left.arrow.right")
                        .font(.title2)
                        .foregroundColor(AppColors.accent)

                    slotButton(tool: toolB, label: "工具 B") {
                        showingPickerForSlot = .b
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)

                if let a = toolA, let b = toolB {
                    compareContent(a: a, b: b)
                } else {
                    emptyState
                }
            }
            .padding(.bottom, 32)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("工具对比")
        .toolbar {
            if toolA != nil && toolB != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        exportLongImage()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(isPresented: $isSharing) {
            if let image = sharedImage {
                ShareSheet(items: [image])
            }
        }
        .sheet(item: $showingPickerForSlot) { slot in
            NavigationStack {
                ComparePickerView { selected in
                    switch slot {
                    case .a: toolA = selected
                    case .b: toolB = selected
                    }
                    showingPickerForSlot = nil
                }
                .environmentObject(store)
            }
        }
    }

    @MainActor
    private func exportLongImage() {
        guard let a = toolA, let b = toolB else { return }
        
        let exportView = VStack(spacing: 20) {
            // Header for image
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("AI 工具深度对比")
                        .font(.title2.bold())
                    Text("由 AIWiki 自动生成")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                Spacer()
                Image(systemName: "bolt.shield.fill")
                    .font(.title)
                    .foregroundColor(AppColors.accent)
            }
            .padding()
            
            // Tool names
            HStack {
                Text(a.name)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                Text("VS")
                    .font(.caption.bold())
                    .foregroundColor(AppColors.accent)
                Text(b.name)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(AppColors.card)
            .cornerRadius(12)
            
            compareContent(a: a, b: b)
        }
        .padding()
        .background(AppColors.background)
        .frame(width: 400) // Fixed width for export
        
        let renderer = ImageRenderer(content: exportView)
        renderer.scale = UIScreen.main.scale
        
        if let image = renderer.uiImage {
            self.sharedImage = image
            self.isSharing = true
        }
    }

    // MARK: - Slot Button

    private func slotButton(tool: AITool?, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                if let tool {
                    ToolAvatar(name: tool.name, size: 48)
                    Text(tool.name)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                } else {
                    ZStack {
                        Circle()
                            .strokeBorder(AppColors.accent.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [6]))
                            .frame(width: 48, height: 48)
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundColor(AppColors.accent)
                    }
                    Text(label)
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppColors.card)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "arrow.left.arrow.right.circle")
                .font(.system(size: 56))
                .foregroundColor(AppColors.accent.opacity(0.4))
            Text("选择两个工具开始对比")
                .font(.headline)
                .foregroundColor(AppColors.textSecondary)
            Text("从不同维度比较 AI 工具的功能、优劣势和定价")
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
        .padding(.horizontal, 40)
    }

    // MARK: - Compare Content

    private func compareContent(a: AITool, b: AITool) -> some View {
        VStack(spacing: 16) {
            // Visual Comparison
            RadarChartView(scoresA: a.radarScoresOrDefault, scoresB: b.radarScoresOrDefault)
                .cardStyle()
            
            compareRow(title: "简介", valueA: a.intro, valueB: b.intro)
            compareRow(title: "公司", valueA: a.company, valueB: b.company)
            compareRow(title: "分类", valueA: a.category, valueB: b.category)

            compareTags(title: "核心功能", tagsA: a.features, tagsB: b.features)

            if let strengthsA = a.strengths, let strengthsB = b.strengths {
                compareBullets(title: "✅ 优势", itemsA: strengthsA, itemsB: strengthsB)
            }

            if let limitsA = a.limitations, let limitsB = b.limitations {
                compareBullets(title: "⚠️ 局限", itemsA: limitsA, itemsB: limitsB)
            }

            if let accessA = a.access, let accessB = b.access {
                compareRow(title: "定价", valueA: accessA.pricing, valueB: accessB.pricing)
                compareRow(title: "平台",
                           valueA: accessA.platforms.joined(separator: ", "),
                           valueB: accessB.platforms.joined(separator: ", "))
                compareRow(title: "API",
                           valueA: accessA.apiAvailable ? "✅ 有" : "❌ 无",
                           valueB: accessB.apiAvailable ? "✅ 有" : "❌ 无")
            }

            // Recommendation Score
            let scoreA = min(5, max(3, (a.features.count + (a.useCases?.count ?? 0)) / 2))
            let scoreB = min(5, max(3, (b.features.count + (b.useCases?.count ?? 0)) / 2))
            compareScore(title: "系统推荐度", scoreA: scoreA, scoreB: scoreB)

            // User ratings
            let ratingA = store.rating(for: a.id)
            let ratingB = store.rating(for: b.id)
            if ratingA > 0 || ratingB > 0 {
                compareRow(title: "我的评分",
                           valueA: ratingA > 0 ? String(repeating: "⭐", count: ratingA) : "未评分",
                           valueB: ratingB > 0 ? String(repeating: "⭐", count: ratingB) : "未评分")
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Compare Row Helpers

    private func compareRow(title: String, valueA: String, valueB: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColors.accent)
            HStack(alignment: .top, spacing: 12) {
                Text(valueA)
                    .font(.subheadline)
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                Text(valueB)
                    .font(.subheadline)
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(14)
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func compareTags(title: String, tagsA: [String], tagsB: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColors.accent)
            HStack(alignment: .top, spacing: 12) {
                tagCloud(tagsA)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                tagCloud(tagsB)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(14)
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func tagCloud(_ tags: [String]) -> some View {
        FlowLayout(spacing: 6) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.accent.opacity(0.15))
                    .foregroundColor(AppColors.accent)
                    .clipShape(Capsule())
            }
        }
    }

    private func compareBullets(title: String, itemsA: [String], itemsB: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColors.accent)
            HStack(alignment: .top, spacing: 12) {
                bulletList(itemsA)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                bulletList(itemsB)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(14)
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func bulletList(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(items, id: \.self) { item in
                Text("• \(item)")
                    .font(.caption)
                    .foregroundColor(AppColors.textPrimary)
            }
        }
    }

    private func compareScore(title: String, scoreA: Int, scoreB: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColors.accent)
            HStack(alignment: .center, spacing: 12) {
                // Score A
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(scoreA).0")
                        .font(.headline)
                        .foregroundColor(AppColors.textPrimary)
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { i in
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundColor(i <= scoreA ? .yellow : AppColors.textSecondary.opacity(0.3))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Divider()
                
                // Score B
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(scoreB).0")
                        .font(.headline)
                        .foregroundColor(AppColors.textPrimary)
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { i in
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundColor(i <= scoreB ? .yellow : AppColors.textSecondary.opacity(0.3))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(14)
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
