import SwiftUI

// MARK: - AI Result View (Screen 15)
struct AIResultView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var selectedVariant = 0
    @State private var isSaved = false

    private let variants: [(name: String, style: DesignStyle, colors: [Color])] = [
        ("Warm Minimalist", .minimalist, [Color(hex: "#F8F4F0"), Color(hex: "#DFC0B5"), Color(hex: "#8B7355")]),
        ("Nordic Sanctuary", .scandinavian, [Color(hex: "#F0EBE3"), Color(hex: "#8B9467"), Color(hex: "#D4A853")]),
        ("Modern Classic", .modern, [Color(hex: "#2C2C2C"), Color(hex: "#C8A96E"), Color(hex: "#F5F5F5")]),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Variant Picker
                VStack(spacing: 12) {
                    Text("3 Design Concepts")
                        .font(AppTheme.Typography.headlineMd)
                        .foregroundStyle(AppTheme.Colors.onSurface)
                    Text("Tap to explore each concept")
                        .font(AppTheme.Typography.bodyMd)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                }
                .padding(.horizontal, 16)

                // Variant Tabs
                HStack(spacing: 8) {
                    ForEach(variants.indices, id: \.self) { idx in
                        Button {
                            withAnimation(.interactiveSpring()) { selectedVariant = idx }
                        } label: {
                            Text(variants[idx].name)
                                .font(AppTheme.Typography.labelSm)
                                .foregroundStyle(selectedVariant == idx ? AppTheme.Colors.primary : AppTheme.Colors.onSurfaceVariant)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    selectedVariant == idx
                                    ? AppTheme.Colors.primaryContainer
                                    : AppTheme.Colors.surfaceContainer
                                )
                                .clipShape(Capsule())
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.horizontal, 16)

                // Design Preview
                let variant = variants[selectedVariant]
                ZStack {
                    LinearGradient(
                        colors: variant.colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 300)

                    // Room layout mockup
                    RoomLayoutMockup(colors: variant.colors)

                    // Overlay badges
                    VStack {
                        HStack {
                            Label(variant.style.rawValue, systemImage: variant.style.icon)
                                .font(AppTheme.Typography.labelSm)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.ultraThinMaterial, in: Capsule())
                            Spacer()
                            Button {
                                withAnimation { isSaved.toggle() }
                            } label: {
                                Image(systemName: isSaved ? "heart.fill" : "heart")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(isSaved ? .red : .white)
                                    .frame(width: 40, height: 40)
                                    .background(.ultraThinMaterial, in: Circle())
                            }
                        }
                        Spacer()
                    }
                    .padding(16)
                }
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
                .shadow(color: .black.opacity(0.1), radius: 20, y: 8)
                .padding(.horizontal, 16)
                .animation(.easeInOut(duration: 0.35), value: selectedVariant)

                // Color Palette
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Colour Palette")

                    HStack(spacing: 10) {
                        ForEach(variant.colors.indices, id: \.self) { idx in
                            Circle()
                                .fill(variant.colors[idx])
                                .frame(width: 44, height: 44)
                                .overlay(Circle().strokeBorder(AppTheme.Colors.outlineVariant, lineWidth: 1))
                                .shadow(color: .black.opacity(0.1), radius: 4)
                        }
                        Spacer()
                        Text("Full Palette")
                            .font(AppTheme.Typography.labelMd)
                            .foregroundStyle(AppTheme.Colors.primary)
                    }
                }
                .padding(.horizontal, 24)

                // Key Features
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Concept Details")

                    ForEach(aiResultDetails, id: \.title) { detail in
                        HStack(spacing: 14) {
                            Image(systemName: detail.icon)
                                .font(.system(size: 16))
                                .foregroundStyle(AppTheme.Colors.primary)
                                .frame(width: 24)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(detail.title)
                                    .font(AppTheme.Typography.labelMd)
                                    .foregroundStyle(AppTheme.Colors.onSurface)
                                Text(detail.value)
                                    .font(AppTheme.Typography.labelSm)
                                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)

                // Actions
                VStack(spacing: 12) {
                    PrimaryButton("View Before & After", icon: "arrow.left.and.right") {
                        router.push(.beforeAfter)
                    }
                    SecondaryButton("Refine Style", icon: "slider.horizontal.3") {
                        router.push(.styleSelection)
                    }
                    OutlinedButton("View Furniture Picks") {
                        router.push(.furnitureRecommendations)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("AI Design Results")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink("Share", item: URL(string: "https://roomiq.app")!)
                    .foregroundStyle(AppTheme.Colors.primary)
            }
        }
    }

    private var aiResultDetails: [(title: String, value: String, icon: String)] {
        [
            ("Furniture Items", "12 recommendations matched to your space", "sofa"),
            ("Estimated Budget", "$2,400 – $3,800", "creditcard"),
            ("Room Fit Score", "96% spatial compatibility", "checkmark.seal"),
            ("AI Confidence", "High — based on 48K scan points", "sparkles"),
        ]
    }
}

// MARK: - Room Layout Mockup
private struct RoomLayoutMockup: View {
    let colors: [Color]

    var body: some View {
        Canvas { context, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Sofa
            context.fill(
                Path(roundedRect: CGRect(x: cx - 60, y: cy - 10, width: 120, height: 45), cornerRadius: 8),
                with: .color(.white.opacity(0.3))
            )
            // Table
            context.fill(
                Path(ellipseIn: CGRect(x: cx - 30, y: cy + 50, width: 60, height: 35)),
                with: .color(.white.opacity(0.2))
            )
            // Rug
            context.fill(
                Path(roundedRect: CGRect(x: cx - 80, y: cy - 30, width: 160, height: 110), cornerRadius: 4),
                with: .color(.white.opacity(0.07))
            )
        }
    }
}

#Preview {
    NavigationStack {
        AIResultView()
            .environment(NavigationRouter())
    }
}
