# AIWiki App Store review checklist

Last updated: March 9, 2026

## Build info

- App name: `AIWiki`
- Bundle ID: `com.next.wiki`
- Platform: `iOS`
- Current marketing version: `1.0.0`
- Current build number: `1`
- Export compliance: `No` (`ITSAppUsesNonExemptEncryption = NO`)

## Submission positioning

- Primary value: offline AI tools directory with localized content, compare flows, prompt studio, and learning scenarios
- Core differentiator: no login, no backend account system, local-only storage for favorites, notes, and usage history
- Intended audience: users exploring AI tools, prompts, and workflow references

## App Store Connect setup

### General

- App name: `AIWiki`
- Subtitle:
  - `zh-Hans`: `离线 AI 工具百科与提示词助手`
  - `en-US`: `Offline AI tools guide and prompt studio`
- Primary category: `Productivity`
- Secondary category: `Education`
- Age rating: `4+`

### Privacy

- Data collection: `No data collected`
- Tracking: `No`
- Privacy policy URL: publish the content from [privacy.md](/Users/yinchaoyu/Downloads/apps/AIWiki/privacy.md) and use that hosted URL in App Store Connect

### Review notes

Use this in the review notes field:

`zh-Hans`

```text
AIWiki 是一个完全离线的 AI 工具百科应用。App 不需要登录，不创建账号，也不连接自有服务器。所有工具资料、学习材料和本地收藏/笔记都保存在设备本地。

审核时可直接进入首页、搜索、对比、收藏、仪表盘和提示词工作室体验完整功能，无需提供测试账号。

App 内“打开官网”会跳转到第三方 AI 工具官方网站，仅用于用户主动查看公开产品页面，不涉及付费解锁或账号体系。
```

`en-US`

```text
AIWiki is a fully offline directory of AI tools. The app does not require login, does not create user accounts, and does not connect to our own backend services. All bundled tool data, favorites, notes, and usage history remain on the device.

During review, you can open Home, Search, Compare, Favorites, Dashboard, and Prompt Studio without any test account.

The "Open Website" action may navigate to official third-party AI product websites only when the user chooses to open them. This is for public reference pages and not for unlocking paid content or account features.
```

## Screenshot set

Current screenshot assets are already present in [screenshots/AppStore](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore).

### iPhone 6.5"

- [iPhone_6_5_01_Home.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPhone_6_5_01_Home.png)
- [iPhone_6_5_02_PromptStudio.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPhone_6_5_02_PromptStudio.png)
- [iPhone_6_5_03_Compare.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPhone_6_5_03_Compare.png)
- [iPhone_6_5_04_Favorites.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPhone_6_5_04_Favorites.png)
- [iPhone_6_5_05_Dashboard.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPhone_6_5_05_Dashboard.png)

### iPhone 6.7"

- [iPhone_6_7_01_Home.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPhone_6_7_01_Home.png)
- [iPhone_6_7_02_PromptStudio.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPhone_6_7_02_PromptStudio.png)
- [iPhone_6_7_03_Compare.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPhone_6_7_03_Compare.png)
- [iPhone_6_7_04_Favorites.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPhone_6_7_04_Favorites.png)
- [iPhone_6_7_05_Dashboard.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPhone_6_7_05_Dashboard.png)

### iPad 12.9"

- [iPad_12_9_01_Home.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPad_12_9_01_Home.png)
- [iPad_12_9_02_PromptStudio.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPad_12_9_02_PromptStudio.png)
- [iPad_12_9_03_Compare.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPad_12_9_03_Compare.png)
- [iPad_12_9_04_Favorites.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPad_12_9_04_Favorites.png)
- [iPad_12_9_05_Dashboard.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPad_12_9_05_Dashboard.png)

### iPad 13"

- [iPad_13_01_Home.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPad_13_01_Home.png)
- [iPad_13_02_PromptStudio.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPad_13_02_PromptStudio.png)
- [iPad_13_03_Compare.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPad_13_03_Compare.png)
- [iPad_13_04_Favorites.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPad_13_04_Favorites.png)
- [iPad_13_05_Dashboard.png](/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/AppStore/iPad_13_05_Dashboard.png)

## Pre-submit checks

- Confirm the build version in App Store Connect matches `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` from [project.yml](/Users/yinchaoyu/Downloads/apps/AIWiki/project.yml)
- Confirm App Privacy is set to `No Data Collected`
- Confirm the privacy policy URL is live
- Confirm `Open Website` links point to official public URLs only
- Confirm screenshots match the selected localizations
- Confirm there is no placeholder text in subtitle, description, keywords, or review notes
- Confirm the localized metadata in [app-store-localized-metadata.md](/Users/yinchaoyu/Downloads/apps/AIWiki/docs/ios/app-store-localized-metadata.md) has been pasted into App Store Connect

## Known review risk to watch

- If the review build still contains simulator-only instability from local development, ignore it; the earlier `xcodebuild` failures were caused by the local `CoreSimulator` environment rather than code signing or localization assets.
- Because the app can open third-party websites, keep the review note explicit that these are optional reference links and not required for core functionality.
