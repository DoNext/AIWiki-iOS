import SwiftUI

struct ToolCardExportView: View {
    let tool: AITool
    let note: String
    
    var body: some View {
        ZStack {
            // Background Layer: Rich Gradient
            LinearGradient(
                colors: [
                    AppColors.accent.opacity(0.15),
                    AppColors.background,
                    AppColors.background
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Decorative Elements: Subtle glowing spots
            Circle()
                .fill(AppColors.accent.opacity(0.1))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: 150, y: -200)
            
            VStack(alignment: .leading, spacing: 24) {
                // Header: Distinctive and Premium
                HStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(AppGradients.accent)
                            .frame(width: 72, height: 72)
                            .shadow(color: AppColors.accent.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Text(String(tool.name.prefix(1)))
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(tool.name)
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(tool.category)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(AppColors.accent)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(AppColors.accent.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
                
                Text(tool.intro)
                    .font(.body)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(3)
                    .padding(.top, 4)
                
                // Section: Core Highlights
                VStack(alignment: .leading, spacing: 14) {
                    Label("核心亮点", systemImage: "sparkles")
                        .font(.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(tool.features.prefix(3), id: \.self) { feature in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.subheadline)
                                    .padding(.top, 2)
                                Text(feature)
                                    .font(.subheadline)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(AppColors.card.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
                
                // Section: My Insights (Note)
                if !note.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("我的智库笔记", systemImage: "pencil.and.outline")
                            .font(.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(note)
                            .font(.subheadline)
                            .italic()
                            .foregroundColor(AppColors.textPrimary)
                            .lineSpacing(4)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.yellow.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color.yellow.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
                
                // Section: Recommended Template
                if let templates = tool.promptTemplates, let first = templates.first {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("💡 推荐指令")
                            .font(.caption.weight(.bold))
                            .foregroundColor(AppColors.accent)
                        
                        Text(first.prompt)
                            .font(.footnote)
                            .foregroundColor(AppColors.textSecondary)
                            .lineLimit(4)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(AppColors.cardHighlight.opacity(0.5))
                    )
                }
                
                Spacer(minLength: 40)
                
                // Footer
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("AIWiki 智库助手")
                            .font(.footnote.weight(.bold))
                            .foregroundColor(AppColors.textPrimary)
                        Text("探索 AI 的无限可能")
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "hand.tap.fill")
                        .font(.title3)
                        .foregroundColor(AppColors.accent)
                    
                    Text("扫码探索")
                        .font(.caption2.weight(.medium))
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(.top, 20)
                .overlay(
                    Rectangle()
                        .fill(AppColors.textSecondary.opacity(0.1))
                        .frame(height: 1)
                        .padding(.top, -10),
                    alignment: .top
                )
            }
            .padding(32)
        }
        .frame(width: 400, height: 700) // Fixed aspect ratio for better sharing
        .clipShape(RoundedRectangle(cornerRadius: 0)) // We want the whole image
    }
}
