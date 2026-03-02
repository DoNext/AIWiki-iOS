import SwiftUI

struct SplashView: View {
    @State private var iconScale: CGFloat = 0.5
    @State private var iconOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var subtitleOpacity: Double = 0
    @State private var glowOpacity: Double = 0

    let onFinished: () -> Void

    var body: some View {
        ZStack {
            // Background
            AppColors.background
                .ignoresSafeArea()

            // Glow effect
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            AppColors.accent.opacity(0.3),
                            AppColors.accent.opacity(0.05),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 200
                    )
                )
                .frame(width: 400, height: 400)
                .opacity(glowOpacity)

            VStack(spacing: 20) {
                // App icon
                ZStack {
                    Circle()
                        .fill(AppGradients.accent)
                        .frame(width: 100, height: 100)

                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundColor(.white)
                }
                .scaleEffect(iconScale)
                .opacity(iconOpacity)

                // App name
                Text("AIWiki")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.textPrimary)
                    .opacity(titleOpacity)

                // Subtitle
                Text("AI 工具百科全书")
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                    .opacity(subtitleOpacity)
            }
        }
        .onAppear {
            // Icon animation
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                iconScale = 1.0
                iconOpacity = 1
            }

            // Glow animation
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                glowOpacity = 1
            }

            // Title animation
            withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
                titleOpacity = 1
            }

            // Subtitle animation
            withAnimation(.easeOut(duration: 0.5).delay(0.6)) {
                subtitleOpacity = 1
            }

            // Dismiss after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                onFinished()
            }
        }
    }
}
