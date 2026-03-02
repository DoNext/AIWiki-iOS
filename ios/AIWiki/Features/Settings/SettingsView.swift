import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: AppStore

    private var appVersionText: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "-"
        return "\(version) (\(build))"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Theme section
                settingsSection("主题") {
                    VStack(spacing: 0) {
                        ForEach(AppTheme.allCases) { item in
                            Button {
                                store.theme = item
                            } label: {
                                HStack {
                                    Text(item.title)
                                        .foregroundColor(AppColors.textPrimary)
                                    Spacer()
                                    if store.theme == item {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(AppColors.accent)
                                            .fontWeight(.semibold)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                            }
                            .buttonStyle(.plain)

                            if item != AppTheme.allCases.last {
                                Divider()
                                    .background(Color.white.opacity(0.06))
                                    .padding(.leading, 16)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(AppColors.card)
                    )
                }

                // App info section
                settingsSection("应用信息") {
                    VStack(spacing: 0) {
                        settingsRow(title: "版本", value: appVersionText)
                        Divider()
                            .background(Color.white.opacity(0.06))
                            .padding(.leading, 16)
                        settingsRow(title: "运行模式", value: "完全离线")
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(AppColors.card)
                    )
                }

                // Data source section
                settingsSection("数据来源") {
                    Text("数据主要来自各 AI 工具官方站点与官方文档，整理后预置在本地。")
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(AppColors.card)
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("设置")
    }

    private func settingsSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(AppColors.textSecondary)
                .padding(.leading, 4)
            content()
        }
    }

    private func settingsRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(AppColors.textPrimary)
            Spacer()
            Text(value)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
