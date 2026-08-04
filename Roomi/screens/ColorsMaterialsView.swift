import SwiftUI

// MARK: - Colors & Materials View (Screen 18)
struct ColorsMaterialsView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var selectedWallColor: ColorSwatch? = nil
    @State private var selectedFloorMaterial: String? = nil
    @State private var selectedAccent: ColorSwatch? = nil

    private let wallPalettes = ColorSwatch.palettes[0]
    private let neutralPalette = ColorSwatch.palettes[1]
    private let floorMaterials = [
        ("Light Oak", "light_oak", Color(hex: "#C8A96E")),
        ("Dark Walnut", "dark_walnut", Color(hex: "#5C3D2E")),
        ("White Marble", "marble", Color(hex: "#F5F0EE")),
        ("Concrete", "concrete", Color(hex: "#A0A0A0")),
        ("Herringbone", "herringbone", Color(hex: "#B8935A")),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Preview
                previewSection

                // Wall Colors
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeader(title: "Wall Colour",
                                  subtitle: selectedWallColor?.name ?? "Select a tone")

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(ColorSwatch.palettes.flatMap { $0 }) { swatch in
                                colorSwatchButton(swatch, isSelected: selectedWallColor?.id == swatch.id) {
                                    withAnimation { selectedWallColor = swatch }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }

                // Floor Material
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeader(title: "Floor Material",
                                  subtitle: selectedFloorMaterial ?? "Select a material")
                        .padding(.horizontal, 24)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(floorMaterials, id: \.0) { name, key, color in
                                Button {
                                    withAnimation { selectedFloorMaterial = name }
                                } label: {
                                    VStack(spacing: 6) {
                                        RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                                            .fill(color)
                                            .frame(width: 64, height: 48)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                                                    .strokeBorder(
                                                        selectedFloorMaterial == name ? AppTheme.Colors.primary : Color.clear,
                                                        lineWidth: 2
                                                    )
                                            )
                                        Text(name)
                                            .font(AppTheme.Typography.labelSm)
                                            .foregroundStyle(
                                                selectedFloorMaterial == name
                                                ? AppTheme.Colors.primary
                                                : AppTheme.Colors.onSurfaceVariant
                                            )
                                    }
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }

                // Accent Colors
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeader(title: "Accent Colour",
                                  subtitle: selectedAccent?.name ?? "Optional pop of colour")
                        .padding(.horizontal, 24)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(ColorSwatch.palettes[1]) { swatch in
                                colorSwatchButton(swatch, isSelected: selectedAccent?.id == swatch.id) {
                                    withAnimation {
                                        selectedAccent = selectedAccent?.id == swatch.id ? nil : swatch
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }

                // Apply
                PrimaryButton("Apply Palette", icon: "paintpalette") {
                    router.push(.furnitureRecommendations)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Colours & Materials")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: Preview
    private var previewSection: some View {
        ZStack {
            // Wall
            (selectedWallColor?.color ?? Color(hex: "#F0EBE3"))
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))

            // Floor strip
            VStack {
                Spacer()
                let floorColor = floorMaterials.first(where: { $0.0 == selectedFloorMaterial })?.2 ?? Color(hex: "#C8A96E")
                floorColor
                    .frame(height: 55)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
            }

            // Furniture silhouette
            VStack {
                Spacer()
                Image(systemName: "sofa")
                    .font(.system(size: 44, weight: .ultraLight))
                    .foregroundStyle((selectedAccent?.color ?? AppTheme.Colors.primary).opacity(0.6))
                    .offset(y: -30)
            }

            // Label
            VStack {
                HStack {
                    Label("Live Preview", systemImage: "eye")
                        .font(AppTheme.Typography.labelSm)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                    Spacer()
                }
                .padding(14)
                Spacer()
            }
        }
        .frame(height: 200)
        .padding(.horizontal, 16)
        .shadow(color: Color(hex: "#8C634F").opacity(0.1), radius: 16, y: 6)
        .animation(.easeInOut(duration: 0.3), value: selectedWallColor?.id)
        .animation(.easeInOut(duration: 0.3), value: selectedFloorMaterial)
    }

    @ViewBuilder
    private func colorSwatchButton(_ swatch: ColorSwatch, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Circle()
                    .fill(swatch.color)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle().strokeBorder(
                            isSelected ? AppTheme.Colors.primary : AppTheme.Colors.outlineVariant,
                            lineWidth: isSelected ? 2.5 : 1
                        )
                    )
                    .overlay(
                        isSelected
                        ? Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                        : nil
                    )
                    .shadow(color: swatch.color.opacity(0.4), radius: 4)

                Text(swatch.name)
                    .font(AppTheme.Typography.labelSm)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    .lineLimit(1)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    NavigationStack {
        ColorsMaterialsView()
            .environment(NavigationRouter())
    }
}
