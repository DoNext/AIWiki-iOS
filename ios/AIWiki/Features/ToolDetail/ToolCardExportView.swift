import SwiftUI

struct ToolCardExportView: View {
    let tool: AITool
    let note: String
    let rating: Int // New: Pass user rating from store
    
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
            
            VStack(alignment: .leading, spacing: 20) {
                // Header Block
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
                        
                        HStack(spacing: 8) {
                            Text(tool.category)
                                .font(.caption.weight(.bold))
                                .foregroundColor(AppColors.accent)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(AppColors.accent.opacity(0.1))
                                .clipShape(Capsule())
                            
                            if rating > 0 {
                                HStack(spacing: 2) {
                                    Image(systemName: "star.fill")
                                        .font(.caption2)
                                    Text("\(rating).0")
                                        .font(.caption.weight(.bold))
                                }
                                .foregroundColor(.yellow)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.yellow.opacity(0.1))
                                .clipShape(Capsule())
                            }
                        }
                    }
                }
                
                Text(tool.intro)
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
                
                // Content Grid: Two columns for richness
                HStack(alignment: .top, spacing: 16) {
                    // Left Column: Features & Highlights
                    VStack(alignment: .leading, spacing: 16) {
                        cardSection(title: "核心亮点", icon: "sparkles") {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(tool.features.prefix(4), id: \.self) { feature in
                                    HStack(alignment: .top, spacing: 6) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.caption2)
                                            .padding(.top, 2)
                                        Text(feature)
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColors.textPrimary)
                                            .lineLimit(2)
                                    }
                                }
                            }
                        }
                        
                        if let bestPractices = tool.bestPractices, !bestPractices.isEmpty {
                            cardSection(title: "最佳实践", icon: "lightbulb.fill") {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(bestPractices.prefix(3), id: \.self) { practice in
                                        Text("• \(practice)")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColors.textSecondary)
                                            .lineLimit(2)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Right Column: Access & Templates
                    VStack(alignment: .leading, spacing: 16) {
                        if let access = tool.access {
                            cardSection(title: "准入信息", icon: "info.circle.fill") {
                                VStack(alignment: .leading, spacing: 6) {
                                    infoItem(label: "价格", value: access.pricing)
                                    infoItem(label: "平台", value: access.platforms.joined(separator: "/"))
                                    infoItem(label: "需账号", value: access.accountRequired ? "是" : "否")
                                }
                            }
                        }
                        
                        if let templates = tool.promptTemplates, let first = templates.first {
                            cardSection(title: "推荐指令", icon: "terminal.fill") {
                                Text(first.prompt)
                                    .font(.system(size: 11))
                                    .italic()
                                    .foregroundColor(AppColors.textSecondary)
                                    .lineLimit(5)
                                    .padding(8)
                                    .background(AppColors.background.opacity(0.5))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Full Width Section: User Notes
                if !note.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("智库心得", systemImage: "pencil.and.outline")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(note)
                            .font(.system(size: 13))
                            .lineSpacing(4)
                            .foregroundColor(AppColors.textPrimary)
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.yellow.opacity(0.1))
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.yellow.opacity(0.2), lineWidth: 1))
                            )
                    }
                    .padding(.top, 4)
                }
                
                Spacer(minLength: 20)
                
                // Enhanced Footer
                VStack(spacing: 12) {
                    Divider().background(AppColors.textSecondary.opacity(0.2))
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("AIWiki 智库助手")
                                .font(.system(size: 12, weight: .bold))
                            Text("助力每一位生产力探索者")
                                .font(.system(size: 10))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("扫码获取更多")
                                    .font(.system(size: 10, weight: .medium))
                                Text("AI 工具干货")
                                    .font(.system(size: 8))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            // Mock QR Code placeholder
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppGradients.accent)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Image(systemName: "qrcode")
                                        .foregroundColor(.white)
                                )
                        }
                    }
                }
            }
            .padding(28)
        }
        .frame(width: 450, height: 800) // Slightly larger canvas for richer content
    }
    
    // MARK: - Helper Views
    
    private func cardSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            content()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.card.opacity(0.7))
                .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
        )
    }
    
    private func infoItem(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(AppColors.textSecondary)
            Text(value)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(1)
        }
    }
}
