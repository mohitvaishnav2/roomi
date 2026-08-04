import SwiftUI

// MARK: - Onboard 2 (Screen 03) — "See what your room could become"
struct Onboard2View: View {
    let onBack: () -> Void
    let onContinue: () -> Void
    let onSkip: () -> Void

    @State private var sliderPosition: CGFloat = 0.5
    @State private var isDragging = false
    @State private var contentOpacity: Double = 0
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            AppTheme.Colors.surface.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Spacer()
                    Button(action: onSkip) {
                        Text("Skip")
                            .font(AppTheme.Typography.labelMd)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(AppTheme.Colors.surfaceContainerHigh.opacity(0.6), in: Capsule())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Before / After Comparison
                GeometryReader { geo in
                    let w = geo.size.width
                    ZStack(alignment: .leading) {
                        // After — warm, styled room (right side)
                        RoundedRectangle(cornerRadius: AppTheme.Radius.xxl)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#F0EBE3"), Color(hex: "#D4A853"), Color(hex: "#8B9467")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                VStack(spacing: 8) {
                                    Image(systemName: "sofa")
                                        .font(.system(size: 60, weight: .ultraLight))
                                        .foregroundStyle(Color(hex: "#8B7355").opacity(0.6))
                                    HStack(spacing: 8) {
                                        Image(systemName: "lamp.floor")
                                        Image(systemName: "table.furniture")
                                        Image(systemName: "photo.artframe")
                                    }
                                    .font(.system(size: 24, weight: .ultraLight))
                                    .foregroundStyle(Color(hex: "#8B7355").opacity(0.5))
                                }
                            )

                        // Before — empty room (left side, clipped)
                        RoundedRectangle(cornerRadius: AppTheme.Radius.xxl)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#C4B8B2"), Color(hex: "#A89891")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                Image(systemName: "square.dashed")
                                    .font(.system(size: 60, weight: .ultraLight))
                                    .foregroundStyle(.white.opacity(0.3))
                            )
                            .frame(width: w * sliderPosition)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))

                        // Divider Handle
                        ZStack {
                            Capsule()
                                .fill(.white)
                                .frame(width: 3, height: 80)
                                .shadow(color: .black.opacity(0.15), radius: 6)

                            Circle()
                                .fill(.white)
                                .frame(width: 44, height: 44)
                                .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
                                .overlay(
                                    Image(systemName: "arrow.left.and.right")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(AppTheme.Colors.primary)
                                )
                        }
                        .offset(x: w * sliderPosition - 22)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    let newPos = (value.location.x) / w
                                    sliderPosition = min(max(newPos, 0.05), 0.95)
                                }
                                .onEnded { _ in isDragging = false }
                        )

                        // Labels
                        VStack {
                            Spacer()
                            HStack {
                                Text("Before")
                                    .font(AppTheme.Typography.labelSm)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 5)
                                    .background(.black.opacity(0.4), in: Capsule())
                                Spacer()
                                Text("After")
                                    .font(AppTheme.Typography.labelSm)
                                    .foregroundStyle(AppTheme.Colors.primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 5)
                                    .background(.white.opacity(0.85), in: Capsule())
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.42)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .shadow(color: Color(hex: "#8C634F").opacity(0.14), radius: 24, y: 12)

                // Content
                VStack(spacing: 14) {
                    Text("See what your room could become.")
                        .font(AppTheme.Typography.headlineLgMobile)
                        .foregroundStyle(AppTheme.Colors.onSurface)
                        .multilineTextAlignment(.center)

                    Text("Explore layouts, styles and colors created around your actual space.")
                        .font(AppTheme.Typography.bodyMd)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        .multilineTextAlignment(.center)

                    PrivacyBadge(label: "Your room data stays under your control.")
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)
                .opacity(contentOpacity)

                Spacer()
            }

            // Bottom Actions
            VStack(spacing: 20) {
                Spacer()
                PageIndicator(count: 3, current: 1)

                HStack(spacing: 12) {
                    OutlinedButton("Back", isFullWidth: false, action: onBack)
                        .frame(maxWidth: .infinity)
                    PrimaryButton("Continue", icon: "arrow.right", action: onContinue)
                        .frame(maxWidth: .infinity, idealWidth: 200)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.3)) { contentOpacity = 1.0 }
            // Auto-animate slider on appear
            withAnimation(.easeInOut(duration: 1.2).delay(0.8)) { sliderPosition = 0.6 }
        }
    }
}

#Preview {
    Onboard2View(onBack: {}, onContinue: {}, onSkip: {})
}
