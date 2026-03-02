import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: AppStore

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
                .listRowBackground(AppColors.card)
            }

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
        }
        .scrollContentBackground(.hidden)
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("设置")
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
}
