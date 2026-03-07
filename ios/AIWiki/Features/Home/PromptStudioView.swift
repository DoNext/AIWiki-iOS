import SwiftUI
import UIKit

struct PromptStudioView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Form States
    @State private var selectedRole = "通用助手"
    @State private var taskDescription = ""
    @State private var selectedTone = "专业"
    @State private var constraints = ""
    @State private var outputFormat = "纯文本"
    
    // Result States
    @State private var generatedPrompt = ""
    @State private var showingCopyAlert = false
    
    let roles = ["通用助手", "资深程序员", "营销专家", "翻译官", "创意作家", "数据分析师"]
    let tones = ["专业", "友好", "严谨", "幽默", "简洁"]
    let formats = ["纯文本", "Markdown 表格", "JSON", "列表", "代码块"]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("我的身份是", selection: $selectedRole) {
                        ForEach(roles, id: \.self) { role in
                            Text(role).tag(role)
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("1. 设定 AI 角色")
                } footer: {
                    Text("设定角色能让 AI 的回答更具针对性")
                }

                Section {
                    TextField("例如：写一篇关于深海探险的小说开头", text: $taskDescription, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Text("2. 描述任务目标")
                }

                Section {
                    Picker("语言风格", selection: $selectedTone) {
                        ForEach(tones, id: \.self) { tone in
                            Text(tone).tag(tone)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("3. 选择语气")
                }

                Section {
                    TextField("例如：不要使用术语，500字以内", text: $constraints)
                    
                    Picker("输出格式", selection: $outputFormat) {
                        ForEach(formats, id: \.self) { format in
                            Text(format).tag(format)
                        }
                    }
                } header: {
                    Text("4. 附加限制与格式")
                }

                Section {
                    Button {
                        generate()
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "wand.and.stars")
                            Text("一键生成提示词")
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .listRowBackground(AppGradients.accent)
                    }
                    .listRowBackground(AppGradients.accent)
                    .disabled(taskDescription.isEmpty)
                }

                if !generatedPrompt.isEmpty {
                    Section {
                        Text(generatedPrompt)
                            .font(.system(.subheadline, design: .monospaced))
                            .padding(.vertical, 8)
                        
                        Button {
                            UIPasteboard.general.string = generatedPrompt
                            showingCopyAlert = true
                        } label: {
                            Label("复制到剪贴板", systemImage: "doc.on.doc")
                                .foregroundColor(AppColors.accent)
                        }
                    } header: {
                        Text("预览生成的 Prompt")
                    }
                }
            }
            .navigationTitle("AI 提示词工作室")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        UIPasteboard.general.string = generatedPrompt
                        dismiss()
                    } label: {
                        Text("完成")
                            .fontWeight(.semibold)
                    }
                    .disabled(generatedPrompt.isEmpty)
                }
            }
            .alert("已复制", isPresented: $showingCopyAlert) {
                Button("好", role: .cancel) { }
            } message: {
                Text("提示词已就绪，快去粘贴给 AI 吧！")
            }
        }
    }

    private func generate() {
        let rolePart = "你现在是一名\(selectedRole)。"
        let taskPart = "\n\n任务：\(taskDescription)"
        let tonePart = "\n请使用\(selectedTone)的语气进行回复。"
        let constraintPart = constraints.isEmpty ? "" : "\n限制：\(constraints)"
        let formatPart = "\n输出格式：\(outputFormat)"
        
        withAnimation {
            generatedPrompt = rolePart + taskPart + tonePart + constraintPart + formatPart
        }
    }
}

#Preview {
    PromptStudioView()
}
