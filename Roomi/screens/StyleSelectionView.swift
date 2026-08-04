import SwiftUI

// MARK: - Style Selection View (Screen 17)
struct StyleSelectionView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var selectedStyles: Set<DesignStyle> = []
    @State private var selectedDetail: DesignStyle? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Header note
                Text("Select styles that resonate with you. You can mix up to 3.")
                    .font(AppTheme.Typography.bodyMd)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                // Style Grid
                LazyVGrid(
                    columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                    spacing: 12
                ) {
                    ForEach(DesignStyle.allCases) { style in
                        Button {
                            withAnimation(.interactiveSpring()) {
                                if selectedStyles.contains(style) {
                                    selectedStyles.remove(style)
                                    if selectedDetail == style { selectedDetail = nil }
                                } else if selectedStyles.count < 3 {
                                    selectedStyles.insert(style)
                                    selectedDetail = style
                                }
                            }
                        } label: {
                            VStack(spacing: 0) {
                                ZStack {
                                    LinearGradient(
                                        colors: style.palette,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    .frame(height: 110)

                                    Image(systemName: style.icon)
                                        .font(.system(size: 32, weight: .ultraLight))
                                        .foregroundStyle(.white.opacity(0.8))

                                    if selectedStyles.contains(style) {
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 22))
                                                    .foregroundStyle(.white)
                                                    .padding(8)
                                            }
                                            Spacer()
                                        }
                                    }
                                }

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(style.rawValue)
                                        .font(AppTheme.Typography.labelMd)
                                        .foregroundStyle(
                                            selectedStyles.contains(style) ? AppTheme.Colors.primary : AppTheme.Colors.onSurface
                                        )
                                    Text(style.description)
                                        .font(AppTheme.Typography.labelSm)
                                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                                        .lineLimit(2)
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    selectedStyles.contains(style)
                                    ? AppTheme.Colors.primaryContainer.opacity(0.5)
                                    : AppTheme.Colors.surfaceContainerLowest
                                )
                            }
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.Radius.xl)
                                    .strokeBorder(
                                        selectedStyles.contains(style) ? AppTheme.Colors.primary : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: Color(hex: "#8C634F").opacity(0.08), radius: 12, y: 3)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.horizontal, 16)

                // Selection Summary
                if !selectedStyles.isEmpty {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Your Mix (\(selectedStyles.count)/3)")
                                .font(AppTheme.Typography.labelMd)
                                .foregroundStyle(AppTheme.Colors.onSurface)
                            Spacer()
                        }
                        .padding(.horizontal, 24)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(Array(selectedStyles), id: \.self) { style in
                                    HStack(spacing: 6) {
                                        Circle()
                                            .fill(LinearGradient(colors: style.palette, startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .frame(width: 16, height: 16)
                                        Text(style.rawValue)
                                            .font(AppTheme.Typography.labelSm)
                                            .foregroundStyle(AppTheme.Colors.onSurface)
                                        Button {
                                            withAnimation { selectedStyles.remove(style) }
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(AppTheme.Colors.surfaceContainer, in: Capsule())
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }

                // Apply CTA
                VStack(spacing: 12) {
                    PrimaryButton("Apply Style Mix", icon: "sparkles") {
                        router.push(.colorsMaterials)
                    }
                    .disabled(selectedStyles.isEmpty)
                    .opacity(selectedStyles.isEmpty ? 0.5 : 1.0)

                    if selectedStyles.isEmpty {
                        Text("Select at least one style to continue")
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Style Selection")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        StyleSelectionView()
            .environment(NavigationRouter())
    }
}
