import SwiftUI

struct ToolCardExportView: View {
    let tool: AITool
    let note: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack(spacing: 16) {
                ToolAvatar(name: tool.name, size: 60)
                VStack(alignment: .leading, spacing: 4) {
                    Text(tool.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.textPrimary)
                    Text(tool.intro)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                }
            }
            .padding(.bottom, 10)
            
            Divider()
            
            // Core Info
            VStack(alignment: .leading, spacing: 12) {
                Text("核心亮点")
                    .font(.headline)
                    .foregroundColor(AppColors.accent)
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(tool.features.prefix(3), id: \.self) { feature in
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(feature)
                                .font(.body)
                                .foregroundColor(AppColors.textPrimary)
                        }
                    }
                }
            }
            
            // Prompt Template (if any)
            if let templates = tool.promptTemplates, let firstTemplate = templates.first {
                VStack(alignment: .leading, spacing: 8) {
                    Text("💡 推荐指令模板")
                        .font(.headline)
                        .foregroundColor(AppColors.accent)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(firstTemplate.title)
                            .font(.subheadline.weight(.semibold))
                        Text(firstTemplate.prompt)
                            .font(.footnote)
                            .italic()
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(12)
                    .background(AppColors.cardHighlight)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            // Personal Note
            if !note.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("📝 我的笔记")
                        .font(.headline)
                        .foregroundColor(AppColors.accent)
                    Text(note)
                        .font(.body)
                        .foregroundColor(AppColors.textPrimary)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.yellow.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            Spacer(minLength: 20)
            
            // Footer
            HStack {
                Text("来自 AIWiki 智库助手")
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
                Image(systemName: "wand.and.stars")
                    .foregroundColor(AppColors.accent)
            }
        }
        .padding(30)
        .frame(width: 400)
        .background(AppColors.card)
    }
}
