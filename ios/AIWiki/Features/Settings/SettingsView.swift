import SwiftUI
import StoreKit
import UIKit

struct SettingsView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showingShareSheet = false
    @State private var showingFeedbackAlert = false

    private var appVersionText: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "-"
        return "\(version) (\(build))"
    }

    var body: some View {
        List {
            Section("主题") {
                Picker("外观模式", selection: $store.theme) {
                    ForEach(AppTheme.allCases) { item in
                        Text(item.title).tag(item)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
                .listRowBackground(AppColors.card)
            }

            Section("统计") {
                infoRow(title: "工具总数", value: "\(store.tools.count)")
                infoRow(title: "分类总数", value: "\(store.categoryGroups().count)")
                infoRow(title: "收藏数", value: "\(store.favoriteTools().count)")
            }
            .listRowBackground(AppColors.card)

            Section("支持我们") {
                Button {
                    requestReview()
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                        Text("给个好评")
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
                        Text("推荐给朋友")
                            .foregroundColor(AppColors.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }

                Button {
                    let email = "feedback@aiwiki.app"
                    if let url = URL(string: "mailto:\(email)"),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    } else {
                        UIPasteboard.general.string = email
                        showingFeedbackAlert = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                        Text("意见反馈")
                            .foregroundColor(AppColors.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            .listRowBackground(AppColors.card)

            Section("应用信息") {
                infoRow(title: "版本", value: appVersionText)
                infoRow(title: "运行模式", value: "完全离线")
            }
            .listRowBackground(AppColors.card)

            Section("数据来源") {
                Text("数据主要来自各 AI 工具官方站点与官方文档，整理后预置在本地。")
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
            }
            .listRowBackground(AppColors.card)

            Section {
                Link(destination: URL(string: "https://github.com/DoNext/AIWiki-iOS")!) {
                    HStack {
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                            .foregroundColor(AppColors.accent)
                        Text("GitHub 开源地址")
                            .foregroundColor(AppColors.textPrimary)
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            .listRowBackground(AppColors.card)
        }
        .scrollContentBackground(.hidden)
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("设置")
        .sheet(isPresented: $showingShareSheet) {
            let text = "推荐一个超棒的 AI 工具百科 App —— AIWiki，收录了 \(store.tools.count) 个 AI 工具，离线可用！"
            ShareSheet(items: [text])
        }
        .alert("意见反馈", isPresented: $showingFeedbackAlert) {
            Button("好的") {}
        } message: {
            Text("邮箱地址已复制到剪贴板：feedback@aiwiki.app")
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
            SKStoreReviewController.requestReview(in: scene)
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
