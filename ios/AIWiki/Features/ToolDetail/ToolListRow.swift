import SwiftUI

struct ToolListRow: View {
    @EnvironmentObject private var store: AppStore

    let tool: AITool

    var body: some View {
        HStack(spacing: 14) {
            ToolAvatar(name: tool.name, size: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(tool.name)
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
                Text(tool.localizedIntro)
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 8)

            Button {
                store.toggleFavorite(tool.id)
            } label: {
                Image(systemName: store.isFavorite(tool.id) ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundColor(store.isFavorite(tool.id) ? AppColors.accent : AppColors.textSecondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text(store.isFavorite(tool.id) ? "取消收藏" : "收藏"))
        }
        .padding(14)
        .cardStyle()
    }
}
