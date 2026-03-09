# 独立模板仓初始化清单

这份文档用于把当前 `release-template/` 目录正式拆成一个独立仓库。

目标是让你在第一次创建 `ios-release-template` 仓库时，按固定步骤完成初始化，不需要再临场判断。

## 建议仓库名

- `ios-release-template`

## 仓库根目录应包含的内容

把当前目录：

- `release-template/`

中的以下内容移动到新仓库根目录：

- `README.md`
- `README.zh-CN.md`
- `Gemfile`
- `ci_scripts/`
- `fastlane/`
- `scripts/`
- `tools/`
- `docs/`

也就是说，拆仓后结构应为：

```text
ios-release-template/
├── README.md
├── README.zh-CN.md
├── Gemfile
├── ci_scripts/
├── fastlane/
├── scripts/
├── tools/
└── docs/
```

## 首个 commit 建议内容

第一批提交只放“模板本体”，不要混入 AIWiki 项目自己的历史说明。

建议首个 commit 包含：

- 通用化后的模板文件
- 安装脚本
- diff 脚本
- 中英文文档

建议 commit message：

```text
chore: initialize ios release template
```

## 首个 tag

建议在首个稳定版本上直接打：

```text
v0.1.0
```

## 拆仓后建议立即补充的文件

### 1. `.gitignore`

至少包含：

```text
.bundle/
vendor/bundle/
fastlane/tmp/
.DS_Store
```

### 2. `LICENSE`

建议根据你的发布习惯选择：

- MIT
- Apache-2.0
- 内部私有仓库则可不放

### 3. `CHANGELOG.md`

建议从 `v0.1.0` 开始记录模板变更，这样各个 app 仓库更容易判断是否要同步升级。

## README 首页应该说明的内容

仓库首页至少要明确：

- 这是“复制式模板”，不是运行时依赖
- 新 app 如何安装
- 新 app 如何比较模板差异
- 哪些值必须替换
- 默认不自动提审

## 新仓库创建后的自检

创建完独立仓库后，先本地自检以下几点：

1. `README.md` 是否不再提 AIWiki 私有业务内容
2. `fastlane/Appfile` 是否仍是占位 bundle id
3. `fastlane/metadata` 是否都是模板文案而不是 AIWiki 专属文案
4. `ci_post_xcodebuild.sh` 是否依赖 `APP_PRODUCT_NAME`
5. `tools/install_into_app.sh` 是否能把模板正确复制到一个测试目录
6. `tools/diff_template_against_app.sh` 是否能输出差异

## 建议的首次验收方法

在一个临时测试目录里执行：

```bash
sh tools/install_into_app.sh /tmp/test-ios-app
```

确认：

- 文件能正确复制
- 目标目录结构符合预期
- 不会遗漏 `fastlane` / `ci_scripts` / `scripts`

然后执行：

```bash
sh tools/diff_template_against_app.sh /tmp/test-ios-app
```

确认模板安装后默认是基本一致的。

## 后续版本管理建议

模板仓库每次改动后：

1. 先更新文档
2. 再改脚本
3. 打语义化 tag

建议 tag 示例：

- `v0.1.0`
- `v0.2.0`
- `v0.2.1`

## App 仓库如何记录来源

每个使用模板的 app 仓库，建议在 README 或内部文档里记录：

- 使用的模板仓库地址
- 使用的模板版本 tag
- 是否有本地定制

例如：

```text
Release automation source: ios-release-template v0.1.0
Local overrides: support URL, metadata locales, screenshot set
```

## 一句话执行顺序

如果你现在就准备拆仓，建议按这个顺序做：

1. 新建 `ios-release-template` 仓库
2. 把 `release-template/` 目录内容移到仓库根目录
3. 补 `.gitignore`
4. 做首个 commit
5. 打 `v0.1.0`
6. 用一个临时 app 目录验证 `install_into_app.sh`
