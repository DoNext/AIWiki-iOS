import SwiftUI
import StoreKit
import UIKit

struct SettingsView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showingShareSheet = false

    private var appVersionText: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "-"
        return "\(version) (\(build))"
    }

    var body: some View {
        List {
            Section(L10n.text(L10n.Settings.theme)) {
                Picker(L10n.text(L10n.Settings.appearance), selection: $store.theme) {
                    ForEach(AppTheme.allCases) { item in
                        Text(item.title).tag(item)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
                .listRowBackground(AppColors.card)
            }

            Section(L10n.text(L10n.Settings.stats)) {
                Button {
                    store.showStats = true
                } label: {
                    HStack {
                        Image(systemName: "chart.bar.xaxis")
                            .foregroundStyle(AppColors.accent)
                        Text(L10n.text(L10n.Settings.dashboard))
                            .foregroundStyle(AppColors.textPrimary)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
                
                infoRow(title: L10n.text(L10n.Settings.toolCount), value: "\(store.tools.count)")
                infoRow(title: L10n.text(L10n.Settings.categoryCount), value: "\(store.categoryGroups().count)")
                infoRow(title: L10n.text(L10n.Settings.favoriteCount), value: "\(store.favoriteTools().count)")
            }
            .listRowBackground(AppColors.card)

            Section(L10n.text(L10n.Settings.library)) {
                NavigationLink {
                    PromptHistoryView()
                        .environmentObject(store)
                } label: {
                    HStack {
                        Image(systemName: "archivebox.fill")
                            .foregroundColor(AppColors.accent)
                        Text(L10n.text(L10n.Settings.promptLibrary))
                            .foregroundColor(AppColors.textPrimary)
                        Spacer()
                        if !store.savedPrompts.isEmpty {
                            Text("\(store.savedPrompts.count)")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(AppColors.accent.opacity(0.1))
                                .foregroundColor(AppColors.accent)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .listRowBackground(AppColors.card)

            Section(L10n.text(L10n.Settings.support)) {
                Button {
                    requestReview()
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                        Text(L10n.text(L10n.Settings.rate))
                            .foregroundColor(AppColors.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }

                Button {
                    showingShareSheet = true
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(AppColors.accent)
                        Text(L10n.text(L10n.Settings.share))
                            .foregroundColor(AppColors.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }

                Link(destination: URL(string: "mailto:yinchyu@gmail.com")!) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                        Text(L10n.text(L10n.Settings.feedback))
                            .foregroundColor(AppColors.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            .listRowBackground(AppColors.card)

            Section(L10n.text(L10n.Settings.appInfo)) {
                infoRow(title: L10n.text(L10n.Settings.version), value: appVersionText)
                infoRow(title: L10n.text(L10n.Settings.mode), value: L10n.text(L10n.Settings.offline))
            }
            .listRowBackground(AppColors.card)

            Section(L10n.text(L10n.Settings.dataSource)) {
                Text(L10n.text(L10n.Settings.dataSourceDesc))
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
            }
            .listRowBackground(AppColors.card)


        }
        .scrollContentBackground(.hidden)
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle(L10n.text(L10n.Settings.title))
        .navigationDestination(isPresented: $store.showStats) {
            ToolUsageStatsView()
        }
        .sheet(isPresented: $showingShareSheet) {
            let text = L10n.format(L10n.Settings.shareTemplate, store.tools.count)
            ShareSheet(items: [text])
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(AppColors.textPrimary)
            Spacer()
            Text(value)
                .foregroundColor(AppColors.textSecondary)
        }
    }

    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            StoreKit.AppStore.requestReview(in: scene)
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
