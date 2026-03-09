import SwiftUI

struct QuizQuestion: Identifiable {
    let id = UUID()
    let text: String
    let options: [String]
    let relatedCategories: [String: [String]] // Option -> Array of categories
}

// MARK: - Quiz Data
let quizQuestions = [
    QuizQuestion(
        text: "你在寻找 AI 的主要用途是什么？",
        options: ["处理文字/写作", "生成图像/设计", "编程辅助", "研究与资料整理", "视频音频处理"],
        relatedCategories: [
            "处理文字/写作": [L10n.Category.writing, L10n.Category.chat],
            "生成图像/设计": [L10n.Category.imageGeneration, L10n.Category.design],
            "编程辅助": [L10n.Category.coding],
            "研究与资料整理": [L10n.Category.dataAnalysis, L10n.Category.chat, L10n.Category.search],
            "视频音频处理": [L10n.Category.video, L10n.Category.audio]
        ]
    ),
    QuizQuestion(
        text: "你的使用频率大概是？",
        options: ["每天高频使用", "偶尔遇到难题才用", "正在学习了解中"],
        relatedCategories: [
            "每天高频使用": [], // No specific category filter, maybe rank higher
            "偶尔遇到难题才用": [],
            "正在学习了解中": []
        ]
    ),
    QuizQuestion(
        text: "预算要求？",
        options: ["仅看完全免费", "接受免费试用+升级", "好用就行，愿意付费"],
        relatedCategories: [
            "仅看完全免费": [], // Handled by complex filter later
            "接受免费试用+升级": [],
            "好用就行，愿意付费": []
        ]
    )
]

struct ToolQuizView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentStep = 0
    @State private var answers: [String] = []
    @State private var isCalculating = false
    @State private var recommendedTools: [AITool] = []

    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                if isCalculating {
                    calculatingView
                } else if !recommendedTools.isEmpty {
                    resultsView
                } else {
                    questionView
                }
            }
            .navigationTitle(L10n.text(L10n.Quiz.title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L10n.text(L10n.Common.close)) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Views
    
    private var questionView: some View {
        VStack(spacing: 30) {
            // Progress Bar
            ProgressView(value: Double(currentStep), total: Double(quizQuestions.count))
                .tint(AppColors.accent)
                .padding(.horizontal, 40)
                .padding(.top, 20)
            
            let question = quizQuestions[currentStep]
            
            Text(L10n.text(question.text))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                ForEach(question.options, id: \.self) { option in
                    Button {
                        handleAnswer(option)
                    } label: {
                        Text(L10n.text(option))
                            .font(.headline)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.cardHighlight)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(AppColors.accent.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .animation(.easeInOut, value: currentStep)
    }
    
    private var calculatingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .controlSize(.large)
                .tint(AppColors.accent)
            Text(L10n.text(L10n.Quiz.matching))
                .font(.headline)
                .foregroundColor(AppColors.textSecondary)
        }
    }
    
    private var resultsView: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                    .padding(.top, 30)
                
                Text(L10n.text(L10n.Quiz.resultTitle))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(L10n.text(L10n.Quiz.resultSubtitle))
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                
                VStack(spacing: 12) {
                    ForEach(recommendedTools) { tool in
                        NavigationLink {
                            ToolDetailView(tool: tool)
                        } label: {
                            ToolListRow(tool: tool)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                
                Button {
                    // Reset
                    currentStep = 0
                    answers.removeAll()
                    recommendedTools.removeAll()
                } label: {
                    Text(L10n.text(L10n.Quiz.restart))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppGradients.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
    }
    
    // MARK: - Logic
    
    private func handleAnswer(_ option: String) {
        answers.append(option)
        if currentStep < quizQuestions.count - 1 {
            withAnimation {
                currentStep += 1
            }
        } else {
            calculateResults()
        }
    }
    
    private func calculateResults() {
        withAnimation {
            isCalculating = true
        }
        
        // Simple mock matching algorithm
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            var preferredCategories: [String] = []
            
            // Extract preferred categories from Q1
            if let targetCategories = quizQuestions[0].relatedCategories[answers[0]] {
                preferredCategories.append(contentsOf: targetCategories)
            }
            
            let allTools = store.tools
            var scoredTools: [(tool: AITool, score: Int)] = allTools.map { ($0, 0) }
            
            for i in 0..<scoredTools.count {
                let tool = scoredTools[i].tool
                if preferredCategories.contains(tool.category) {
                    scoredTools[i].score += 5
                }
                
                // Q3 budget logic
                if answers.count > 2 && answers[2] == "仅看完全免费" {
                    let pricingText = (tool.localizedAccessPricing ?? tool.access?.pricing ?? "").lowercased()
                    if pricingText.contains("免费") || pricingText.contains("free") || pricingText.contains("开源") || pricingText.contains("open source") {
                        scoredTools[i].score += 3
                    } else {
                        scoredTools[i].score -= 5 // Penalty if not free
                    }
                }
            }
            
            scoredTools.sort { $0.score > $1.score }
            
            withAnimation {
                self.recommendedTools = Array(scoredTools.map { $0.tool }.prefix(3))
                self.isCalculating = false
            }
        }
    }
}
