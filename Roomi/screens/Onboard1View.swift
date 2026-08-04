import SwiftUI

// MARK: - Onboard 1 (Screen 02) — "Understand your space"
struct Onboard1View: View {
    let onContinue: () -> Void
    let onSkip: () -> Void

    @State private var heroScale: CGFloat = 0.95
    @State private var contentOpacity: Double = 0
    @State private var scanLineY: CGFloat = -1

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

                // Hero Room Visual
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.Radius.xxl)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#EDE0D4"), Color(hex: "#DFC0B5"), Color(hex: "#C9A99A")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    // Grid overlay
                    Canvas { context, size in
                        let spacing: CGFloat = 30
                        context.opacity = 0.15
                        var xPos: CGFloat = 0
                        while xPos < size.width {
                            var path = Path()
                            path.move(to: CGPoint(x: xPos, y: 0))
                            path.addLine(to: CGPoint(x: xPos, y: size.height))
                            context.stroke(path, with: .color(.white), lineWidth: 0.5)
                            xPos += spacing
                        }
                        var yPos: CGFloat = 0
                        while yPos < size.height {
                            var path = Path()
                            path.move(to: CGPoint(x: 0, y: yPos))
                            path.addLine(to: CGPoint(x: size.width, y: yPos))
                            context.stroke(path, with: .color(.white), lineWidth: 0.5)
                            yPos += spacing
                        }
                    }

                    // Scan line
                    GeometryReader { geo in
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [.clear, AppTheme.Colors.primary.opacity(0.7), .clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 2)
                            .offset(y: geo.size.height * scanLineY)
                            .blur(radius: 1)
                    }

                    // Room icon elements
                    VStack(spacing: 12) {
                        Image(systemName: "sofa")
                            .font(.system(size: 52, weight: .ultraLight))
                            .foregroundStyle(.white.opacity(0.5))
                        HStack(spacing: 16) {
                            ForEach(["ruler", "angle", "viewfinder.rectangular"], id: \.self) { icon in
                                Label(icon, systemImage: icon)
                                    .labelStyle(.iconOnly)
                                    .font(.system(size: 18, weight: .light))
                                    .foregroundStyle(.white.opacity(0.6))
                                    .frame(width: 36, height: 36)
                                    .background(.white.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }

                    // AR measurement overlay
                    MeasurementOverlay()

                    // Fade at bottom
                    LinearGradient(
                        colors: [.clear, AppTheme.Colors.surface.opacity(0.0), AppTheme.Colors.surface],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                }
                .frame(height: UIScreen.main.bounds.height * 0.44)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
                .scaleEffect(heroScale)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .shadow(color: Color(hex: "#8C634F").opacity(0.12), radius: 24, y: 12)

                // Content
                VStack(spacing: 12) {
                    Text("Understand your space.")
                        .font(AppTheme.Typography.headlineLgMobile)
                        .foregroundStyle(AppTheme.Colors.primary)
                        .multilineTextAlignment(.center)

                    Text("Scan a room and RoomIQ builds a spatial model you can design around.")
                        .font(AppTheme.Typography.bodyMd)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .opacity(contentOpacity)

                Spacer()
            }

            // Bottom Action Area
            VStack(spacing: 20) {
                Spacer()
                PageIndicator(count: 3, current: 0)

                PrimaryButton("Continue", icon: "arrow.right", action: onContinue)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) { heroScale = 1.0 }
            withAnimation(.easeOut(duration: 0.5).delay(0.4)) { contentOpacity = 1.0 }
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: true).delay(0.5)) { scanLineY = 1.0 }
        }
    }
}

// MARK: - AR Measurement Overlay
private struct MeasurementOverlay: View {
    var body: some View {
        ZStack {
            // Horizontal dimension line
            HStack(spacing: 0) {
                Circle().fill(.white.opacity(0.8)).frame(width: 5, height: 5)
                Rectangle()
                    .fill(.white.opacity(0.6))
                    .frame(height: 1)
                    .overlay(Rectangle().fill(.white.opacity(0.0)).frame(height: 1), alignment: .center)
                Circle().fill(.white.opacity(0.8)).frame(width: 5, height: 5)
            }
            .frame(width: 120)
            .offset(y: 60)

            // Dimension label
            Text("5.2 m")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(.ultraThinMaterial, in: Capsule())
                .offset(y: 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .padding(.bottom, 40)
        .padding(.leading, 24)
    }
}

#Preview {
    Onboard1View(onContinue: {}, onSkip: {})
}
