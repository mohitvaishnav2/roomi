import SwiftUI

// MARK: - Onboard 3 (Screen 04) — Privacy & AI Features
struct Onboard3View: View {
    let onBack: () -> Void
    let onGetStarted: () -> Void

    @State private var visibleFeature: Int = 0
    @State private var contentOpacity: Double = 0

    private let features: [(icon: String, title: String, body: String, color: Color)] = [
        ("sparkles", "AI Design Intelligence", "Powered by Apple Intelligence — generates personalised room concepts from your spatial scan.", AppTheme.Colors.primary),
        ("cube.transparent", "RealityKit Placement", "Preview furniture in your actual space using AR before you buy.", AppTheme.Colors.tertiary),
        ("lock.shield", "Privacy by Design", "Scans stay on-device. Nothing leaves your phone without your permission.", Color(hex: "#5B8DB8")),
    ]

    var body: some View {
        ZStack {
            AppTheme.Colors.surface.ignoresSafeArea()

            VStack(spacing: 0) {
                // Hero Illustration
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.Radius.xxl)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#FEF8F4"), Color(hex: "#F8D7CC"), Color(hex: "#DFC0B5")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    VStack(spacing: 20) {
                        // Animated feature icon
                        ZStack {
                            ForEach(0..<features.count, id: \.self) { idx in
                                ZStack {
                                    Circle()
                                        .fill(features[idx].color.opacity(0.15))
                                        .frame(width: 100, height: 100)
                                    Image(systemName: features[idx].icon)
                                        .font(.system(size: 40, weight: .ultraLight))
                                        .foregroundStyle(features[idx].color)
                                }
                                .opacity(visibleFeature == idx ? 1 : 0)
                                .scaleEffect(visibleFeature == idx ? 1.0 : 0.8)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: visibleFeature)
                            }
                        }

                        // Feature dots selector
                        HStack(spacing: 8) {
                            ForEach(0..<features.count, id: \.self) { idx in
                                Button { withAnimation { visibleFeature = idx } } label: {
                                    Circle()
                                        .fill(visibleFeature == idx ? features[idx].color : AppTheme.Colors.outlineVariant)
                                        .frame(width: 8, height: 8)
                                }
                            }
                        }
                    }
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
                .padding(.horizontal, 24)
                .padding(.top, 32)
                .shadow(color: Color(hex: "#8C634F").opacity(0.1), radius: 20, y: 8)

                // Feature Cards
                VStack(spacing: 12) {
                    ForEach(0..<features.count, id: \.self) { idx in
                        let f = features[idx]
                        HStack(spacing: 16) {
                            ZStack {
                                Circle().fill(f.color.opacity(0.12)).frame(width: 48, height: 48)
                                Image(systemName: f.icon)
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(f.color)
                            }
                            VStack(alignment: .leading, spacing: 3) {
                                Text(f.title)
                                    .font(AppTheme.Typography.labelMd)
                                    .foregroundStyle(AppTheme.Colors.onSurface)
                                Text(f.body)
                                    .font(AppTheme.Typography.labelSm)
                                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                                    .lineLimit(2)
                            }
                        }
                        .padding(16)
                        .background(
                            visibleFeature == idx
                            ? f.color.opacity(0.06)
                            : AppTheme.Colors.surfaceContainerLowest
                        )
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
                        .animation(.easeInOut(duration: 0.2), value: visibleFeature)
                        .onTapGesture { withAnimation { visibleFeature = idx } }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .opacity(contentOpacity)

                Spacer()
            }

            // Bottom Actions
            VStack(spacing: 20) {
                Spacer()
                PageIndicator(count: 3, current: 2)

                PrimaryButton("Get Started", icon: "arrow.right", action: onGetStarted)

                Button(action: onBack) {
                    Text("Back")
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.3)) { contentOpacity = 1.0 }
            startFeatureCycle()
        }
    }

    private func startFeatureCycle() {
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { timer in
            withAnimation { visibleFeature = (visibleFeature + 1) % features.count }
        }
    }
}

#Preview {
    Onboard3View(onBack: {}, onGetStarted: {})
}
