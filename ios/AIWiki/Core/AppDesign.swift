import SwiftUI
import UIKit

// MARK: - Colors (Adaptive: light + dark)
enum AppColors {
    static let background = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
            : UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1)
    })

    static let card = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
            : UIColor.white
    })

    static let cardHighlight = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.15, green: 0.15, blue: 0.17, alpha: 1)
            : UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1)
    })

    static let accent = Color(red: 0.45, green: 0.35, blue: 0.9)
    static let accentLight = Color(red: 0.6, green: 0.5, blue: 1.0)

    static let textPrimary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? .white : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    })

    static let textSecondary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(white: 0.55, alpha: 1)
            : UIColor(white: 0.45, alpha: 1)
    })
}

// MARK: - Gradients
enum AppGradients {
    static let accent = LinearGradient(
        colors: [
            Color(red: 0.45, green: 0.35, blue: 0.9),
            Color(red: 0.6, green: 0.4, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardOverlay = LinearGradient(
        colors: [
            Color.white.opacity(0.08),
            Color.clear
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Category Icons
enum CategoryIcon {
    static func symbol(for category: String) -> String {
        switch category {
        case "聊天机器人": return "bubble.left.and.bubble.right.fill"
        case "编程助手": return "chevron.left.forwardslash.chevron.right"
        case "图像生成": return "photo.artframe"
        case "数据分析": return "chart.bar.xaxis"
        case "多模态模型": return "brain.head.profile"
        case "音频处理": return "waveform"
        case "视频工具": return "film"
        case "写作助手": return "pencil.and.outline"
        case "搜索引擎": return "magnifyingglass"
        case "办公效率": return "briefcase.fill"
        default: return "sparkles"
        }
    }
}

// MARK: - Card Style Modifier
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColors.card)
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

// MARK: - Tool Avatar
struct ToolAvatar: View {
    let name: String
    var size: CGFloat = 44

    var body: some View {
        Text(String(name.prefix(1)))
            .font(.system(size: size * 0.45, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(AppGradients.accent)
            )
    }
}
