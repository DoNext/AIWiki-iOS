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
                    Text(L10n.text(L10n.Search.noCategoryResults))
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
        .searchable(text: $query, prompt: L10n.text(L10n.Search.inCategoryPrompt))
        .navigationTitle(L10n.text(category))
        .navigationBarTitleDisplayMode(.inline)
    }
}
