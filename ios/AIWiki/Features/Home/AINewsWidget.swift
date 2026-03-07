import SwiftUI

struct AINewsWidget: View {
    @State private var currentIndex = 0
    @State private var direction: CGFloat = 1 // 1 for next, -1 for previous
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    private let tips = [
        (title: "每日 AI 贴士", content: "使用「Prompt 指南」中的结构化模版，可以让模型回复更专业。"),
        (title: "行业动态", content: "多模态大模型近期在视频生成领域取得重大突破，效率提升 3 倍。"),
        (title: "效率专家", content: "尝试在提示词中加上‘一步步思考’，可以显著提高逻辑推理准确度。"),
        (title: "新功能上线", content: "AI 枢纽现在支持一键切换多个模型对比，快去体验吧！"),
        (title: "安全提醒", content: "在与大模型交流时，请勿输入个人隐私信息或公司核心机密。")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(tips[currentIndex].title, systemImage: "sparkles")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.accent)
                
                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(0..<tips.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? AppColors.accent : AppColors.textSecondary.opacity(0.3))
                            .frame(width: 4, height: 4)
                    }
                }
            }
            
            Text(tips[currentIndex].content)
                .font(.subheadline)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .id(currentIndex)
                .transition(.asymmetric(
                    insertion: .move(edge: direction > 0 ? .trailing : .leading).combined(with: .opacity),
                    removal: .move(edge: direction > 0 ? .leading : .trailing).combined(with: .opacity)
                ))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.card)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(AppColors.cardHighlight, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 {
                        showNext()
                    } else if value.translation.width > 50 {
                        showPrevious()
                    }
                }
        )
        .onReceive(timer) { _ in
            showNext()
        }
    }
    
    private func showNext() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            direction = 1
            currentIndex = (currentIndex + 1) % tips.count
        }
    }
    
    private func showPrevious() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            direction = -1
            currentIndex = (currentIndex - 1 + tips.count) % tips.count
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        AINewsWidget()
            .padding()
    }
}
