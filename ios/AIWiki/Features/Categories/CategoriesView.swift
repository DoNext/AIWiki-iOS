import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        Group {
            if let error = store.loadError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(store.categoryGroups(), id: \.name) { item in
                    NavigationLink {
                        CategoryToolsView(category: item.name)
                    } label: {
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("\(item.count)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("分类")
    }
}
