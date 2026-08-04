import SwiftUI

// MARK: - Splash View (Screen 01)
struct SplashView: View {
    let onFinish: () -> Void

    @State private var logoScale: CGFloat = 0.7
    @State private var logoOpacity: Double = 0
    @State private var titleOffset: CGFloat = 20
    @State private var titleOpacity: Double = 0
    @State private var subtitleOpacity: Double = 0
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            AppTheme.Colors.surface.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Logo
                ZStack {
                    // Pulse ring
                    Circle()
                        .stroke(AppTheme.Colors.primary.opacity(0.12), lineWidth: 1)
                        .frame(width: 130, height: 130)
                        .scaleEffect(pulseScale)

                    Circle()
                        .stroke(AppTheme.Colors.primary.opacity(0.07), lineWidth: 1)
                        .frame(width: 160, height: 160)
                        .scaleEffect(pulseScale * 1.1)

                    // Floorplan shape
                    FloorplanShape()
                        .stroke(AppTheme.Colors.secondary.opacity(0.7), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .frame(width: 80, height: 80)

                    // AI Sparkle
                    Image(systemName: "sparkles")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.primary)
                        .offset(x: 14, y: 14)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .frame(width: 128, height: 128)
                .padding(.bottom, 32)

                // Brand name
                Text("RoomIQ AI")
                    .font(AppTheme.Typography.displayLg)
                    .foregroundStyle(AppTheme.Colors.onSurface)
                    .offset(y: titleOffset)
                    .opacity(titleOpacity)

                // Tagline
                Text("Understand your space.")
                    .font(AppTheme.Typography.bodyLg)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    .opacity(subtitleOpacity)
                    .padding(.top, 8)

                Spacer()
            }
        }
        .onAppear { runEntrance() }
        .task {
            try? await Task.sleep(for: .seconds(3.0))
            onFinish()
        }
    }

    private func runEntrance() {
        withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.1)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.6).delay(0.5)) {
            titleOffset = 0
            titleOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.8)) {
            subtitleOpacity = 1.0
        }
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay(1.0)) {
            pulseScale = 1.15
        }
    }
}

// MARK: - Floorplan Shape
private struct FloorplanShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height

        // Outer L-shape
        path.move(to: CGPoint(x: w * 0.2, y: h * 0.8))
        path.addLine(to: CGPoint(x: w * 0.2, y: h * 0.2))
        path.addLine(to: CGPoint(x: w * 0.8, y: h * 0.2))
        path.addLine(to: CGPoint(x: w * 0.8, y: h * 0.5))

        // Inner room divider (dashed effect via separate subpath)
        path.move(to: CGPoint(x: w * 0.4, y: h * 0.8))
        path.addLine(to: CGPoint(x: w * 0.4, y: h * 0.5))
        path.addLine(to: CGPoint(x: w * 0.8, y: h * 0.5))

        return path
    }
}

#Preview {
    SplashView(onFinish: {})
}
