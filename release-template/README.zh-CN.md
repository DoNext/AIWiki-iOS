# Release Template

这个目录是从 AIWiki 当前可用的 Xcode Cloud + App Store Connect 发布链路中抽出来的可复用模板。

适用场景：

- 新 iOS App 首次接入 Xcode Cloud 发布
- 需要自动上传 binary / metadata / screenshots
- 希望保留“手动提交审核”能力

## 包含内容

- `Gemfile`
- `ci_scripts/`
- `fastlane/`
- `scripts/release_to_app_store.sh`

## 复制到新仓库后的第一步

优先使用安装脚本：

```bash
sh release-template/tools/install_into_app.sh /path/to/your-app-repo
```

如果你只是参考，也可以手工复制这些文件到新仓库根目录。

如果要比较模板和某个 App 仓库当前有哪些差异，可以运行：

```bash
sh release-template/tools/diff_template_against_app.sh /path/to/your-app-repo
```

然后立即替换这些内容：

- `APP_BUNDLE_ID`
- `APP_PRODUCT_NAME`
- App 名称
- 副标题
- 描述
- 关键词
- 推广文本
- 更新说明
- 技术支持 URL
- 审核联系人信息

## 必须检查的地方

1. Xcode 工程里的 `MARKETING_VERSION`
2. Xcode 工程里的 `CURRENT_PROJECT_VERSION`
3. `fastlane/metadata` 下每个语言目录
4. `screenshots/AppStore` 下的截图是否只保留一套有效设备映射

## 推荐环境变量

至少配置：

- `XCODE_CLOUD_AUTO_SUBMIT=1`
- `XCODE_CLOUD_RELEASE_WORKFLOW=Release`
- `APP_BUNDLE_ID=<新 bundle id>`
- `APP_PRODUCT_NAME=<Xcode 产物名，例如 MyApp>`
- `APP_STORE_CONNECT_KEY_ID=<key id>`
- `APP_STORE_CONNECT_ISSUER_ID=<issuer id>`
- `APP_STORE_CONNECT_KEY_CONTENT=<p8 原文或 base64>`
- `APP_REVIEW_FIRST_NAME=<名字>`
- `APP_REVIEW_LAST_NAME=<姓>`
- `APP_REVIEW_PHONE=<电话>`
- `APP_REVIEW_EMAIL=<邮箱>`
- `APP_REVIEW_NOTES=<审核备注>`
- `MARKETING_VERSION_OVERRIDE=<比如 1.0.0>`

## 如果你不想自动提交审核

增加：

- `APP_STORE_AUTO_SUBMIT=0`

## 如果你只想复用已有 build 修 metadata

增加：

- `APP_STORE_SKIP_BINARY_UPLOAD=1`
- `APP_STORE_EXISTING_BUILD_NUMBER=<已存在 build>`

## 建议 workflow 配置

- 名称：`Release`
- 触发：仅手动触发
- 动作：Archive for App Store distribution

不要开：

- 分支变更自动触发
- 默认自动提审

## 先看这两份文档

- [新 App 发布模板（中文）](./docs/new-app-release-template.zh-CN.md)
- [发布流程说明（英文）](./docs/app-store-release.md)
