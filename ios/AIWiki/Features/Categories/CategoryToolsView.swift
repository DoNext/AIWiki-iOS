import SwiftUI

struct CategoryToolsView: View {
    @EnvironmentObject private var store: AppStore
    @State private var query: String = ""

    let category: String

    private var tools: [AITool] {
        store.filteredTools(in: category, query: query)
    }

    var body: some View {
        Group {
            if tools.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("该分类下无匹配结果")
                        .foregroundColor(.secondary)
                }
            } else {
                List(tools, id: \.id) { tool in
                    NavigationLink {
                        ToolDetailView(tool: tool)
                    } label: {
                        ToolListRow(tool: tool)
                    }
                }
                .listStyle(.plain)
            }
        }
        .searchable(text: $query, prompt: "分类内搜索")
        .navigationTitle(L10n.text(category))
        .navigationBarTitleDisplayMode(.inline)
    }
}
