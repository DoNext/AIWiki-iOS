# 新 App 发布模板

这份文档把 AIWiki 当前可用的 Xcode Cloud + App Store Connect 发布流程提炼成一个可复用模板，目标是让后续新 iOS App 不再从头踩一遍相同的坑。

## 可直接复用的文件

新仓库可以直接复制这些文件，并保持相同相对路径：

- `Gemfile`
- `fastlane/Appfile`
- `fastlane/Fastfile`
- `scripts/release_to_app_store.sh`
- `ci_scripts/ci_post_clone.sh`
- `ci_scripts/ci_post_xcodebuild.sh`
- `ci_scripts/exportOptions-appstore.plist`

同时保留这两个目录约定：

- `fastlane/metadata/<locale>`
- `screenshots/AppStore/<locale>`

## 每个 App 必须替换的内容

以下内容不能直接照搬，必须按新 App 调整：

- `APP_BUNDLE_ID`
- App 名称 / 副标题 / 描述 / 关键词 / 更新说明
- 技术支持 URL
- 隐私政策 URL
- 审核联系人信息
- 截图资源
- `MARKETING_VERSION_OVERRIDE`

## 每个语言至少要有的元数据文件

`fastlane/metadata/<locale>` 目录下，至少应包含：

- `name.txt`
- `subtitle.txt`
- `description.txt`
- `keywords.txt`
- `promotional_text.txt`
- `release_notes.txt`
- `support_url.txt`

如果 App Store Connect 仍然提示缺少 `whatsNew`，通常表示：

- `release_notes.txt` 没成功同步
- 或者当前这个版本记录已经进入了半完成状态，需要先在 App Store Connect 后台手工补一次

## Xcode Cloud workflow 模板

建议为每个 App 建一个归档 workflow，名称固定为 `Release`。

推荐配置：

- 触发方式：仅手动触发
- Scheme：App 主 scheme
- 动作：Archive for App Store distribution
- 开启自定义脚本

建议关闭：

- 分支变更自动触发
- 自动提交审核（除非你明确需要）

## 推荐的 Xcode Cloud 环境变量

必填：

- `XCODE_CLOUD_AUTO_SUBMIT=1`
- `XCODE_CLOUD_RELEASE_WORKFLOW=Release`
- `APP_BUNDLE_ID=<你的 bundle id>`
- `APP_STORE_CONNECT_KEY_ID=<API key id>`
- `APP_STORE_CONNECT_ISSUER_ID=<issuer id>`
- `APP_STORE_CONNECT_KEY_CONTENT=<p8 原文或 base64>`
- `APP_REVIEW_FIRST_NAME=<名字>`
- `APP_REVIEW_LAST_NAME=<姓>`
- `APP_REVIEW_PHONE=<电话>`
- `APP_REVIEW_EMAIL=<邮箱>`
- `APP_REVIEW_NOTES=<审核备注>`
- `MARKETING_VERSION_OVERRIDE=<例如 1.1.0>`

可选：

- `APP_STORE_LOCALES=en-US,zh-Hans`
- `APP_STORE_AUTO_SUBMIT=0`
- `APP_STORE_SKIP_BINARY_UPLOAD=1`
- `APP_STORE_EXISTING_BUILD_NUMBER=<已存在并处理完成的 build>`

建议这样使用：

- 如果你只想上传并停在后台，设置 `APP_STORE_AUTO_SUBMIT=0`
- 如果你已经有可用 build，只想修 metadata / 提审，设置 `APP_STORE_SKIP_BINARY_UPLOAD=1`
- 如果 metadata-only 模式要复用旧 build，设置 `APP_STORE_EXISTING_BUILD_NUMBER=<旧 build 号>`

## 首发时仍需手工完成的后台配置

这些项目通常不值得强行自动化，建议首发时手工完成一次：

- 创建 App 记录
- 协议 / 税务 / 银行信息
- App 隐私
- 技术支持 URL
- 隐私政策 URL
- 价格与地区
- 年龄分级

## 版本号规则

- `CURRENT_PROJECT_VERSION` 对应 build number，可跟随 CI 构建号递增
- `MARKETING_VERSION` / `CFBundleShortVersionString` 对应 App Store 版本号
- 每次新版本提审都必须提升 marketing version
- 不要让项目长期保留 `1.0.0` 作为默认值

## 截图规则

不要在仓库中同时保留两套会被 App Store Connect 映射到同一设备槽位的截图。

AIWiki 当前就踩过这个坑：

- `iPad_12_9_*`
- `iPad_13_*`

在 App Store Connect 里会落到同一个 iPad 截图位，结果造成重复上传。对于每个截图槽位，只保留一套规范截图。

## 常见故障与对应处理

如果出现 `Invalid Pre-Release Train`：

- 提升 `MARKETING_VERSION_OVERRIDE`
- 确认归档和提审使用的是同一个新版本号

如果出现 `Build number does not exist`：

- 设置 `APP_STORE_SKIP_BINARY_UPLOAD=1`
- 设置 `APP_STORE_EXISTING_BUILD_NUMBER=<已处理完成的 build>`

如果截图上传重复：

- 从 `screenshots/AppStore` 删除多余那一套截图
- 在 App Store Connect 后台把重复截图先清掉一次

如果 metadata 提交时报缺字段：

- 先检查 `support_url.txt`
- 检查 `release_notes.txt`
- 如果版本记录已经进入半完成状态，优先去 App Store Connect 后台手工补齐一次

## 推荐的最小重复发布流程

对一个新 App，建议固定采用下面这套流程：

1. 把截图和 metadata 放进仓库。
2. 手动运行 `Release` workflow。
3. 让 Xcode Cloud 完成 archive 和上传。
4. 如果需要修 metadata，再用 `APP_STORE_SKIP_BINARY_UPLOAD=1` + `APP_STORE_EXISTING_BUILD_NUMBER=<已处理 build>` 走 metadata-only 重提交流程。
5. 默认手动点“提交审核”，只有明确需要时才打开自动提审。
