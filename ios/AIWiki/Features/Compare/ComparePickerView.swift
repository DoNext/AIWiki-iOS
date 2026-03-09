import SwiftUI

struct ComparePickerView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    let onSelect: (AITool) -> Void

    private var results: [AITool] {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return store.tools.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        }
        let keyword = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return store.tools.filter { $0.localizedSearchText.contains(keyword) }
    }

    var body: some View {
        List {
            ForEach(results) { tool in
                Button {
                    onSelect(tool)
                } label: {
                    HStack(spacing: 12) {
                        ToolAvatar(name: tool.name, size: 36)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(tool.name)
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(AppColors.textPrimary)
                            Text(tool.localizedCategory)
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .listRowBackground(AppColors.card)
            }
        }
        .searchable(text: $query, prompt: "搜索工具")
        .navigationTitle("选择工具")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("取消") { dismiss() }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppColors.background.ignoresSafeArea())
    }
}
