import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var store: AppStore
    @State private var query: String = ""

    private var results: [AITool] {
        store.filteredTools(query: query)
    }

    var body: some View {
        Group {
            if let error = store.loadError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if results.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundColor(AppColors.textSecondary)
                    Text("输入关键词搜索 AI 工具")
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.background.ignoresSafeArea())
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(results, id: \.id) { tool in
                            NavigationLink {
                                ToolDetailView(tool: tool)
                            } label: {
                                ToolListRow(tool: tool)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .background(AppColors.background.ignoresSafeArea())
            }
        }
        .searchable(text: $query, prompt: "搜索名称、简介、功能")
        .navigationTitle("搜索")
    }
}
