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
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("无结果")
                        .foregroundColor(.secondary)
                }
            } else {
                List(results, id: \.id) { tool in
                    NavigationLink {
                        ToolDetailView(tool: tool)
                    } label: {
                        ToolListRow(tool: tool)
                    }
                }
                .listStyle(.plain)
            }
        }
        .searchable(text: $query, prompt: "搜索名称、简介、功能")
        .navigationTitle("搜索")
    }
}
