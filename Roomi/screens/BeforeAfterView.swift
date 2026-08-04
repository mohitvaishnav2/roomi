import SwiftUI

// MARK: - Before After View (Screen 16)
struct BeforeAfterView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var sliderPosition: CGFloat = 0.5
    @State private var isDragging = false
    @State private var showInfo = false

    var body: some View {
        VStack(spacing: 0) {
            // Full screen comparison
            GeometryReader { geo in
                let w = geo.size.width

                ZStack(alignment: .leading) {
                    // After — designed room
                    LinearGradient(
                        colors: [Color(hex: "#F0EBE3"), Color(hex: "#D4A853"), Color(hex: "#8B9467")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .overlay(
                        VStack(spacing: 12) {
                            Image(systemName: "sofa")
                                .font(.system(size: 80, weight: .ultraLight))
                                .foregroundStyle(Color(hex: "#8B7355").opacity(0.5))
                            Text("After AI Design")
                                .font(AppTheme.Typography.headlineMd)
                                .foregroundStyle(Color(hex: "#8B7355").opacity(0.7))
                        }
                    )

                    // Before — raw room
                    LinearGradient(
                        colors: [Color(hex: "#B8B0A8"), Color(hex: "#9A948E")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .overlay(
                        VStack(spacing: 12) {
                            Image(systemName: "square.dashed")
                                .font(.system(size: 80, weight: .ultraLight))
                                .foregroundStyle(.white.opacity(0.3))
                            Text("Before Scan")
                                .font(AppTheme.Typography.headlineMd)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    )
                    .frame(width: w * sliderPosition)
                    .clipped()

                    // Handle
                    ZStack {
                        Capsule()
                            .fill(.white)
                            .frame(width: 3, height: 100)
                            .shadow(color: .black.opacity(0.2), radius: 6)

                        Circle()
                            .fill(.white)
                            .frame(width: 48, height: 48)
                            .shadow(color: .black.opacity(0.2), radius: 8, y: 2)
                            .overlay(
                                Image(systemName: "arrow.left.and.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(AppTheme.Colors.primary)
                            )
                            .scaleEffect(isDragging ? 1.1 : 1.0)
                            .animation(.interactiveSpring(response: 0.25), value: isDragging)
                    }
                    .offset(x: w * sliderPosition - 24)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isDragging = true
                                sliderPosition = min(max(value.location.x / w, 0.02), 0.98)
                            }
                            .onEnded { _ in isDragging = false }
                    )

                    // Labels
                    VStack {
                        HStack {
                            Text("Before")
                                .font(AppTheme.Typography.labelMd)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(.black.opacity(0.4), in: Capsule())

                            Spacer()

                            Text("After")
                                .font(AppTheme.Typography.labelMd)
                                .foregroundStyle(AppTheme.Colors.primary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(.white.opacity(0.85), in: Capsule())
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        Spacer()
                    }
                }
            }
            .frame(maxHeight: .infinity)

            // Bottom Panel
            VStack(spacing: 16) {
                // Info toggle
                Button {
                    withAnimation { showInfo.toggle() }
                } label: {
                    HStack {
                        Text("Design Details")
                            .font(AppTheme.Typography.labelMd)
                            .foregroundStyle(AppTheme.Colors.onSurface)
                        Spacer()
                        Image(systemName: showInfo ? "chevron.down" : "chevron.up")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }
                }

                if showInfo {
                    VStack(spacing: 8) {
                        ForEach(["Style: Scandinavian Minimalist", "Palette: Warm neutrals + sage", "Furniture: 12 items suggested", "Space change: +32% perceived area"], id: \.self) { detail in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(AppTheme.Colors.tertiary)
                                    .font(.system(size: 14))
                                Text(detail)
                                    .font(AppTheme.Typography.bodyMd)
                                    .foregroundStyle(AppTheme.Colors.onSurface)
                                Spacer()
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                HStack(spacing: 12) {
                    SecondaryButton("View in AR", icon: "cube.transparent") {
                        router.push(.arPlacement)
                    }
                    PrimaryButton("See Furniture") {
                        router.push(.furnitureRecommendations)
                    }
                }
            }
            .padding(20)
            .background(.ultraThinMaterial)
        }
        .navigationTitle("Before & After")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    NavigationStack {
        BeforeAfterView()
            .environment(NavigationRouter())
    }
}
