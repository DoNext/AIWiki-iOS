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
                    Picker(L10n.text(L10n.PromptStudio.roleLabel), selection: $selectedRole) {
                        ForEach(roles, id: \.self) { role in
                            Text(L10n.text(role)).tag(role)
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text(L10n.text(L10n.PromptStudio.roleHeader))
                } footer: {
                    Text(L10n.text(L10n.PromptStudio.roleFooter))
                }

                Section {
                    TextField(L10n.text(L10n.PromptStudio.taskPlaceholder), text: $taskDescription, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Text(L10n.text(L10n.PromptStudio.taskHeader))
                }

                Section {
                    Picker(L10n.text(L10n.PromptStudio.toneLabel), selection: $selectedTone) {
                        ForEach(tones, id: \.self) { tone in
                            Text(L10n.text(tone)).tag(tone)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text(L10n.text(L10n.PromptStudio.toneHeader))
                }

                Section {
                    TextField(L10n.text(L10n.PromptStudio.constraintsPlaceholder), text: $constraints)
                    
                    Picker(L10n.text(L10n.PromptStudio.outputFormatLabel), selection: $outputFormat) {
                        ForEach(formats, id: \.self) { format in
                            Text(L10n.text(format)).tag(format)
                        }
                    }
                } header: {
                    Text(L10n.text(L10n.PromptStudio.extraHeader))
                }

                Section {
                    Button {
                        generate()
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "wand.and.stars")
                            Text(L10n.text(L10n.PromptStudio.generate))
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
                            Label(L10n.text(L10n.PromptStudio.copyToClipboard), systemImage: "doc.on.doc")
                                .foregroundColor(AppColors.accent)
                        }

                        Button {
                            store.savePrompt(role: selectedRole, task: taskDescription, content: generatedPrompt)
                            hasSaved = true
                        } label: {
                            Label(hasSaved ? L10n.text(L10n.PromptStudio.savedToLibrary) : L10n.text(L10n.PromptStudio.saveToLibrary), systemImage: hasSaved ? "checkmark.circle.fill" : "archivebox")
                                .foregroundColor(hasSaved ? .green : AppColors.accent)
                        }
                        .disabled(hasSaved)
                    } header: {
                        Text(L10n.text(L10n.PromptStudio.preview))
                    }
                }
            }
            .navigationTitle(L10n.text(L10n.PromptStudio.title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L10n.text(L10n.Common.cancel)) { dismiss() }
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
            .alert(L10n.text(L10n.Common.copied), isPresented: $showingCopyAlert) {
                Button(L10n.text(L10n.Common.ok), role: .cancel) { }
            } message: {
                Text(L10n.text(L10n.PromptStudio.copiedMessage))
            }
        }
    }

    private func generate() {
        let rolePart = String(format: L10n.text(L10n.PromptStudio.roleTemplate), L10n.text(selectedRole))
        let taskPart = String(format: L10n.text(L10n.PromptStudio.taskTemplate), taskDescription)
        let tonePart = String(format: L10n.text(L10n.PromptStudio.toneTemplate), L10n.text(selectedTone))
        let constraintPart = constraints.isEmpty ? "" : String(format: L10n.text(L10n.PromptStudio.constraintsTemplate), constraints)
        let formatPart = String(format: L10n.text(L10n.PromptStudio.formatTemplate), L10n.text(outputFormat))
        
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
                            Label(L10n.text(L10n.Common.delete), systemImage: "trash")
                        }
                        
                        Button {
                            UIPasteboard.general.string = item.content
                        } label: {
                            Label(L10n.text(L10n.Common.copy), systemImage: "doc.on.doc")
                        }
                        .tint(AppColors.accent)
                    }
                }
            }
            .navigationTitle(L10n.text(L10n.PromptStudio.historyTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L10n.text(L10n.Common.close)) { dismiss() }
                }
            }
            .overlay {
                if store.savedPrompts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "clock.badge.exclamationmark")
                            .font(.system(size: 48))
                            .foregroundColor(AppColors.textSecondary.opacity(0.5))
                            Text(L10n.text(L10n.PromptStudio.noHistory))
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
                    Text(L10n.text(L10n.PromptStudio.taskDetail))
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
                        Text(L10n.text(L10n.PromptStudio.generatedPrompt))
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
        .navigationTitle(L10n.text(L10n.PromptStudio.detailTitle))
        .alert(L10n.text(L10n.Common.copied), isPresented: $showingCopyAlert) {
            Button(L10n.text(L10n.Common.ok), role: .cancel) { }
        }
    }
}

#Preview {
    PromptStudioView()
}
