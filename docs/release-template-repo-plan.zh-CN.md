# 独立发布模板仓库方案

这份文档描述如何把当前 AIWiki 的发布能力拆成一个独立仓库，供多个 iOS App 复用。

目标：

- 复用 Xcode Cloud + App Store Connect 发布链路
- 不让各个 App 在运行时强依赖外部仓库
- 保持每个 App 仓库可独立发布、可审计、可回滚

## 推荐方案

使用：

- 一个独立模板仓库
- 每个 App 仓库本地保存一份模板文件
- 通过初始化脚本 / 同步脚本按需更新

不推荐：

- 在 CI 里每次临时 clone 外部发布仓库再执行
- `git submodule`

可接受但次优：

- `git subtree`

## 为什么不建议运行时依赖外部仓库

发布链路是高敏感路径，运行时拉外部仓库会带来这些问题：

- 外部仓库不可用时，所有 App 一起受影响
- 模板仓库的主分支变更可能直接打挂旧 App
- 排查问题时要跨两个仓库和两个版本
- 审计发布逻辑时不够稳定

因此，更稳的做法是：

- 模板仓库提供“可复制的文件”
- 每个 App 仓库保存一份具体版本

## 独立仓库建议名称

可选：

- `ios-release-template`
- `appstore-release-kit`
- `xcode-cloud-appstore-template`

建议用：

- `ios-release-template`

## 独立仓库推荐目录结构

```text
ios-release-template/
├── README.md
├── template/
│   ├── Gemfile
│   ├── ci_scripts/
│   │   ├── ci_post_clone.sh
│   │   ├── ci_post_xcodebuild.sh
│   │   └── exportOptions-appstore.plist
│   ├── fastlane/
│   │   ├── Appfile
│   │   ├── Fastfile
│   │   └── metadata/
│   │       ├── en-US/
│   │       └── zh-Hans/
│   └── scripts/
│       └── release_to_app_store.sh
├── docs/
│   ├── setup.zh-CN.md
│   ├── setup.en.md
│   ├── troubleshooting.zh-CN.md
│   └── environment-vars.md
├── examples/
│   ├── minimal-app/
│   └── metadata-sample/
└── tools/
    ├── install_into_app.sh
    └── diff_template_against_app.sh
```

## template 目录职责

`template/` 里只放真正要复制到 App 仓库里的内容。

要求：

- 不带 AIWiki 专属 bundle id
- 不带 AIWiki 专属文案
- 不带 AIWiki 专属截图
- 保留占位符和模板注释

例如：

- `APP_BUNDLE_ID=com.example.app`
- metadata 文件用占位文本
- `support_url.txt` 用 `https://example.com/support`

## docs 目录职责

放所有“人要读”的东西：

- 接入步骤
- Xcode Cloud 配置
- App Store Connect 必填项
- 常见错误解释
- metadata-only 重提交流程

## examples 目录职责

给使用者看一个最小可工作的样例：

- 一套最小 metadata
- 一个最小 App 接入后的目录示例

## tools 目录职责

这里建议至少有两个脚本。

### 1. `install_into_app.sh`

作用：

- 把 `template/` 内容复制到目标 App 仓库
- 如果目标文件不存在则创建
- 如果目标文件存在则提示冲突
- 不覆盖 App 自己的 metadata / 截图内容

建议行为：

- 支持 `--force`
- 支持 `--dry-run`
- 输出“复制了哪些文件”
- 输出“还需要手工替换哪些变量”

### 2. `diff_template_against_app.sh`

作用：

- 比较模板仓库和目标 App 仓库中的公共文件差异
- 帮助判断某个 App 是否要同步模板升级

## 每个 App 仓库如何接入

推荐方式：

1. 首次接入时，运行模板仓库里的安装脚本
2. 模板文件复制进 App 仓库
3. App 仓库自己提交这些文件
4. 后续模板有升级时，再手动同步

这样 App 仓库始终是自包含的。

## 建议保留在 App 仓库里的内容

这些内容应该留在各自 App 仓库，不应该从模板仓库动态读取：

- `fastlane/metadata/*`
- `screenshots/AppStore/*`
- App 自己的 bundle id
- 审核联系人信息说明
- 具体版本号策略

## 模板仓库需要参数化的内容

模板中最好统一用占位符：

- `__APP_BUNDLE_ID__`
- `__APP_NAME__`
- `__SUPPORT_URL__`
- `__PRIVACY_URL__`
- `__DEFAULT_LOCALES__`

安装脚本可以做简单替换。

## Xcode Cloud 复用原则

Xcode Cloud 里的 workflow 名称、环境变量命名建议统一。

统一约定：

- workflow 名：`Release`
- 手动触发
- 默认 `APP_STORE_AUTO_SUBMIT=0`

常用环境变量统一命名：

- `APP_STORE_CONNECT_KEY_ID`
- `APP_STORE_CONNECT_ISSUER_ID`
- `APP_STORE_CONNECT_KEY_CONTENT`
- `APP_STORE_SKIP_BINARY_UPLOAD`
- `APP_STORE_EXISTING_BUILD_NUMBER`
- `MARKETING_VERSION_OVERRIDE`

## 版本管理建议

模板仓库本身要打 tag。

例如：

- `v0.1.0`
- `v0.2.0`

每个 App 仓库在 README 或文档里记录：

- 当前使用的模板版本
- 是否做过本地定制

这样以后排查差异会简单很多。

## 最推荐的实际落地方式

如果你现在就要开始拆仓，我建议按下面顺序：

1. 先把当前 `release-template/` 提炼成真正中性的 `template/`
2. 去掉 AIWiki 专属 metadata 默认值
3. 加一个 `tools/install_into_app.sh`
4. 再把它单独拆成新仓库

不要先拆仓再慢慢整理，否则会把 AIWiki 的历史细节原样带过去。

## 一句话结论

最好的方案不是“所有 App 运行时拉一个公共仓库”，而是：

**独立模板仓库 + App 仓库本地落地模板文件 + 用安装/同步脚本做复用。**
