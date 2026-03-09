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
                        
                        Text(String(tool.localizedName.prefix(1)))
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(tool.localizedName)
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundColor(AppColors.textPrimary)
                        
                        HStack(spacing: 8) {
                            Text(tool.localizedCategory)
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
                
                Text(tool.localizedIntro)
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
                
                // Content Grid: Two columns for richness
                HStack(alignment: .top, spacing: 16) {
                    // Left Column: Features & Highlights
                    VStack(alignment: .leading, spacing: 16) {
                        cardSection(title: L10n.text(L10n.ExportCard.highlights), icon: "sparkles") {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(tool.localizedFeatures.prefix(4), id: \.self) { feature in
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
                        
                        if let bestPractices = tool.localizedBestPractices, !bestPractices.isEmpty {
                            cardSection(title: L10n.text(L10n.Detail.bestPractices), icon: "lightbulb.fill") {
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
                            cardSection(title: L10n.text(L10n.ExportCard.accessInfo), icon: "info.circle.fill") {
                                VStack(alignment: .leading, spacing: 6) {
                                    infoItem(label: L10n.text(L10n.Common.pricing), value: tool.localizedAccessPricing ?? access.pricing)
                                    infoItem(label: L10n.text(L10n.Common.platform), value: (tool.localizedAccessPlatforms ?? access.platforms).joined(separator: "/"))
                                    infoItem(label: L10n.text(L10n.ExportCard.account), value: access.accountRequired ? L10n.text(L10n.Common.yes) : L10n.text(L10n.Common.no))
                                }
                            }
                        }
                        
                        let templates = tool.localizedPromptTemplates
                        if let first = templates.first {
                            cardSection(title: L10n.text(L10n.ExportCard.suggestedPrompt), icon: "terminal.fill") {
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
                        Label(L10n.text(L10n.ExportCard.note), systemImage: "pencil.and.outline")
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
                            Text(L10n.text(L10n.ExportCard.footerTitle))
                                .font(.system(size: 12, weight: .bold))
                            Text(L10n.text(L10n.ExportCard.footerSubtitle))
                                .font(.system(size: 10))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(L10n.text(L10n.ExportCard.qrTitle))
                                    .font(.system(size: 10, weight: .medium))
                                Text(L10n.text(L10n.ExportCard.qrSubtitle))
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
