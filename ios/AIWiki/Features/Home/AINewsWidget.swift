import SwiftUI

struct AINewsWidget: View {
    @State private var currentIndex = 0
    @State private var direction: CGFloat = 1 // 1 for next, -1 for previous
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    private let tips = [
        (title: "news.tip.daily.title", content: "news.tip.daily.body"),
        (title: "news.industry.title", content: "news.industry.body"),
        (title: "news.productivity.title", content: "news.productivity.body"),
        (title: "news.feature.title", content: "news.feature.body"),
        (title: "news.safety.title", content: "news.safety.body")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(L10n.text(tips[currentIndex].title), systemImage: "sparkles")
                    .font(.caption2.weight(.semibold))
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
            
            Text(L10n.text(tips[currentIndex].content))
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
