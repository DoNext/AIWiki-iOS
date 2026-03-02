import SwiftUI

struct ToolListRow: View {
    @EnvironmentObject private var store: AppStore

    let tool: AITool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(tool.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(tool.intro)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 8)

            Button {
                store.toggleFavorite(tool.id)
            } label: {
                Image(systemName: store.isFavorite(tool.id) ? "star.fill" : "star")
                    .foregroundColor(store.isFavorite(tool.id) ? .yellow : .secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(store.isFavorite(tool.id) ? "取消收藏" : "收藏")
        }
        .padding(.vertical, 4)
    }
}
