import SwiftUI
import UIKit

struct AIConsoleView: View {
    private struct ConsoleTool: Identifiable {
        let id: String
        let name: String
        let url: String
    }

    @Environment(\.dismiss) private var dismiss
    @State private var url: URL
    @State private var reloadTrigger = false
    @State private var showingPromptStudio = false
    @State private var currentToolURL: String
    
    private let tools = [
        ConsoleTool(id: "chatgpt", name: "对话大模型", url: "https://chatgpt.com"),
        ConsoleTool(id: "claude", name: "逻辑推理", url: "https://claude.ai"),
        ConsoleTool(id: "gemini", name: "多模态智脑", url: "https://gemini.google.com"),
        ConsoleTool(id: "kimi", name: "高效率搜索", url: "https://kimi.moonshot.cn"),
        ConsoleTool(id: "deepseek", name: "工程化助手", url: "https://chat.deepseek.com")
    ]
    
    init(initialURL: String = "https://chatgpt.com") {
        _currentToolURL = State(initialValue: initialURL)
        _url = State(initialValue: URL(string: initialURL)!)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tool Switcher Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(tools) { tool in
                            Button {
                                if let newURL = URL(string: tool.url) {
                                    url = newURL
                                    currentToolURL = tool.url
                                    reloadTrigger = true
                                }
                            } label: {
                            Text(tool.name)
                                .font(.subheadline.weight(currentToolURL == tool.url ? .bold : .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(currentToolURL == tool.url ? AppColors.accent : AppColors.cardHighlight)
                                .foregroundStyle(currentToolURL == tool.url ? .white : AppColors.textPrimary)
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
