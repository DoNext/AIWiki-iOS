import SwiftUI

struct ExportPreviewView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var showingShare = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 10)
                        .padding()
                }
            }
            .navigationTitle(L10n.text(L10n.Detail.previewTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L10n.text(L10n.Common.close)) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingShare = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showingShare) {
                ShareSheet(items: [image])
            }
        }
    }
}
