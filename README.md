# AIWiki - AI 知识百科 & 工具导航

[English](#english) | [简体中文](#简体中文)

---

<a name="english"></a>
# AIWiki (iOS)

AIWiki is a minimalist, privacy-focused iOS application designed to provide a comprehensive knowledge base of AI tools and technologies. It works entirely offline, ensuring your data stays on your device.

## 📱 Screenshots

<div align="center">
  <img src="screenshots/iPhone_17_Pro_Max_01_Home.png" width="200" alt="Home Screen">
  <img src="screenshots/iPhone_17_Pro_Max_02_PromptStudio.png" width="200" alt="Prompt Studio">
  <img src="screenshots/iPhone_17_Pro_Max_05_Dashboard.png" width="200" alt="Dashboard">
</div>

*iPad View:*
<div align="center">
  <img src="screenshots/iPad_Pro_(12.9-inch)_(6th_generation)_01_Home.png" width="400" alt="iPad Home">
</div>

## ✨ Key Features

- **🚀 100% Offline**: All AI tool data is pre-packaged. No network requests, no latency.
- **🛡️ Privacy First**: No tracking, no analytics, no accounts. Your favorites are stored locally.
- **🔍 Intelligent Search**: Fast, fuzzy search through tool names, categories, and descriptions.
- **📚 Categorized Browsing**: Explore AI tools by category: Chatbots, Image Generation, Coding Assistants, and more.
- **⭐ Local Favorites**: Save tools you use frequently for quick access.
- **🌓 Dark Mode**: Full support for system-wide light/dark themes.

## 🛠️ Technical Stack

- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **Programming Language**: Swift 5.0+
- **Database**: SQLite with FTS5 for high-performance full-text search.
- **Project Structure**: Clean architecture with separate layers for Features, Core, and Data.

## 🏗️ Build Instructions

This project uses **XcodeGen** to manage the project file.

1. Ensure you have [XcodeGen](https://github.com/yonaskolb/XcodeGen) installed.
2. Run the following command in the root directory to generate the `.xcodeproj`:
   ```bash
   xcodegen generate
   ```
3. Open `AIWiki.xcodeproj` in Xcode and build for your target device or simulator.

---

<a name="简体中文"></a>
# AIWiki (iOS) - 简体中文

AIWiki 是一款极简且注重隐私的 iOS 应用，旨在提供全面的 AI 工具与技术知识库。它完全离线运行，确保您的数据保留在设备上。

## ✨ 核心特性

- **🚀 100% 离线**: 所有 AI 工具数据均为预打包。无网络请求，零延迟。
- **🛡️ 隐私至上**: 无追踪、无统计、无账号。您的收藏仅存储在本地。
- **🔍 智能搜索**: 支持对工具名称、分类和描述进行快速模糊搜索。
- **📚 分类浏览**: 按分类探索 AI 工具：聊天机器人、图像生成、编程助手等。
- **⭐ 本地收藏**: 收藏常用工具，方便快速访问。
- **🌓 深色模式**: 完美支持系统浅色/深色主题。

## 🛠️ 技术栈

- **UI 框架**: SwiftUI
- **架构**: MVVM (Model-View-ViewModel)
- **编程语言**: Swift 5.0+
- **数据库**: 使用 SQLite (FTS5) 实现高性能全文检索。
- **项目结构**: 清晰的架构，包含 Features、Core 和 Data 分层。

## 🏗️ 构建说明

本项目使用 **XcodeGen** 管理项目文件。

1. 确保已安装 [XcodeGen](https://github.com/yonaskolb/XcodeGen)。
2. 在根目录运行以下命令生成 `.xcodeproj`：
   ```bash
   xcodegen generate
   ```
3. 在 Xcode 中打开 `AIWiki.xcodeproj` 并构建。

## 📄 License

Project is licensed under the [MIT License](LICENSE).
