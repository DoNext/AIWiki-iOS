import SwiftUI
import UIKit

struct AIConsoleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var url: URL
    @State private var reloadTrigger = false
    @State private var showingPromptStudio = false
    @State private var currentToolName: String
    
    private let tools = [
        (name: "对话大模型", url: "https://chatgpt.com"),
        (name: "逻辑推理", url: "https://claude.ai"),
        (name: "多模态智脑", url: "https://gemini.google.com"),
        (name: "高效率搜索", url: "https://kimi.moonshot.cn"),
        (name: "工程化助手", url: "https://chat.deepseek.com")
    ]
    
    init(initialToolName: String = "对话大模型", initialURL: String = "https://chatgpt.com") {
        _currentToolName = State(initialValue: initialToolName)
        _url = State(initialValue: URL(string: initialURL)!)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tool Switcher Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(tools, id: \.name) { tool in
                            Button {
                                if let newURL = URL(string: tool.url) {
                                    url = newURL
                                    currentToolName = tool.name
                                    reloadTrigger = true
                                }
                            } label: {
                            Text(tool.name)
                                .font(.subheadline.weight(currentToolName == tool.name ? .bold : .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(currentToolName == tool.name ? AppColors.accent : AppColors.cardHighlight)
                                .foregroundStyle(currentToolName == tool.name ? .white : AppColors.textPrimary)
                                .clipShape(.rect(cornerRadius: 20))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .background(AppColors.background)
                
                Divider()
                
                // Active WebView
                AIWebView(url: url, reloadTrigger: $reloadTrigger)
                    .id(url) // Force recreate on URL change for clean state
                
                // Bottom Instruction Bar
                HStack {
                    Button {
                        showingPromptStudio = true
                    } label: {
                        HStack {
                            Image(systemName: "wand.and.stars")
                            Text(L10n.text(L10n.Console.openPromptStudio))
                        }
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(AppGradients.accent)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 12))
                    }
                    
                    Spacer()
                    
                    Text(L10n.text(L10n.Console.tip))
                        .font(.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding()
                .background(AppColors.card)
            }
            .navigationTitle(L10n.text(L10n.Console.title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.text(L10n.Common.close)) { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        reloadTrigger = true
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .sheet(isPresented: $showingPromptStudio) {
                PromptStudioView()
            }
        }
    }
}

#Preview {
    AIConsoleView()
}
