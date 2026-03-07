import SwiftUI
import UIKit

struct PromptStudioView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: AppStore
    
    // Form States
    @State private var selectedRole = "通用助手"
    @State private var taskDescription = ""
    @State private var selectedTone = "专业"
    @State private var constraints = ""
    @State private var outputFormat = "纯文本"
    
    // Result States
    @State private var generatedPrompt = ""
    @State private var showingCopyAlert = false
    @State private var showingHistory = false
    @State private var hasSaved = false
    
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

                        Button {
                            store.savePrompt(role: selectedRole, task: taskDescription, content: generatedPrompt)
                            hasSaved = true
                        } label: {
                            Label(hasSaved ? "已保存到库" : "保存到提示词库", systemImage: hasSaved ? "checkmark.circle.fill" : "archivebox")
                                .foregroundColor(hasSaved ? .green : AppColors.accent)
                        }
                        .disabled(hasSaved)
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
                        showingHistory = true
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .sheet(isPresented: $showingHistory) {
                PromptHistoryView()
                    .environmentObject(store)
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
            hasSaved = false
        }
    }
}

struct PromptHistoryView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.savedPrompts) { item in
                    NavigationLink {
                        PromptDetailView(item: item)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(item.role)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AppColors.accent.opacity(0.1))
                                    .foregroundColor(AppColors.accent)
                                    .clipShape(Capsule())
                                
                                Spacer()
                                
                                Text(item.date, style: .date)
                                    .font(.caption2)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            Text(item.task)
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(AppColors.textPrimary)
                                .lineLimit(1)
                            
                            Text(item.content)
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            store.deletePrompt(id: item.id)
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                        
                        Button {
                            UIPasteboard.general.string = item.content
                        } label: {
                            Label("复制", systemImage: "doc.on.doc")
                        }
                        .tint(AppColors.accent)
                    }
                }
            }
            .navigationTitle("历史记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") { dismiss() }
                }
            }
            .overlay {
                if store.savedPrompts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "clock.badge.exclamationmark")
                            .font(.system(size: 48))
                            .foregroundColor(AppColors.textSecondary.opacity(0.5))
                        Text("暂无保存记录")
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
        }
    }
}

struct PromptDetailView: View {
    let item: SavedPrompt
    @State private var showingCopyAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Text(item.role)
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.accent.opacity(0.1))
                        .foregroundColor(AppColors.accent)
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    Text(item.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                // Task
                VStack(alignment: .leading, spacing: 8) {
                    Text("描述的任务目标")
                        .font(.caption.bold())
                        .foregroundColor(AppColors.accent)
                    Text(item.task)
                        .font(.body)
                        .foregroundColor(AppColors.textPrimary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppColors.card)
                .cornerRadius(12)
                
                // Content
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("生成的 Prompt")
                            .font(.caption.bold())
                            .foregroundColor(AppColors.accent)
                        Spacer()
                        Button {
                            UIPasteboard.general.string = item.content
                            showingCopyAlert = true
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .font(.subheadline)
                        }
                    }
                    
                    Text(item.content)
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(AppColors.textPrimary)
                        .textSelection(.enabled)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppColors.card)
                .cornerRadius(12)
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("记录详情")
        .alert("已复制", isPresented: $showingCopyAlert) {
            Button("好", role: .cancel) { }
        }
    }
}

#Preview {
    PromptStudioView()
}
