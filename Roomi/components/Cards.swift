import SwiftUI

// MARK: - Room Card
struct RoomCard: View {
    let project: RoomProject
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: 0) {
                // Gradient Hero
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        colors: project.gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 140)

                    HStack {
                        Image(systemName: project.roomType.icon)
                            .font(.system(size: 36, weight: .ultraLight))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    if project.isCompleted {
                        Label("Completed", systemImage: "checkmark.circle.fill")
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.primary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.ultraThinMaterial, in: Capsule())
                            .padding(12)
                    }
                }

                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(AppTheme.Colors.onSurface)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Text(project.roomType.rawValue)
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        Text("·")
                            .foregroundStyle(AppTheme.Colors.outlineVariant)
                        Text(project.style.rawValue)
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }
                }
                .padding(14)
            }
            .background(AppTheme.Colors.surfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
            .shadow(color: Color(hex: "#8C634F").opacity(0.08), radius: 16, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Style Card
struct StyleCard: View {
    let style: DesignStyle
    var isSelected: Bool = false
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                ZStack {
                    LinearGradient(
                        colors: style.palette,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 100)

                    Image(systemName: style.icon)
                        .font(.system(size: 28, weight: .light))
                        .foregroundStyle(.white.opacity(0.9))
                }

                HStack {
                    Text(style.rawValue)
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.onSurface)
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(AppTheme.Colors.primary)
                            .font(.system(size: 16))
                    }
                }
                .padding(12)
                .background(isSelected ? AppTheme.Colors.primaryContainer : AppTheme.Colors.surfaceContainerLowest)
            }
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.xl)
                    .strokeBorder(
                        isSelected ? AppTheme.Colors.primary : Color.clear,
                        lineWidth: 2
                    )
            )
            .shadow(color: Color(hex: "#8C634F").opacity(0.08), radius: 12, y: 3)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Inspiration Card
struct InspirationCard: View {
    let item: InspirationItem
    var onSaveToggle: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                LinearGradient(
                    colors: item.gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 120)
                .overlay(
                    Image(systemName: item.style.icon)
                        .font(.system(size: 32, weight: .ultraLight))
                        .foregroundStyle(.white.opacity(0.5))
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(AppTheme.Colors.onSurface)
                        .lineLimit(1)
                    Text(item.style.rawValue)
                        .font(AppTheme.Typography.labelSm)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                }
                .padding(10)
            }
            .background(AppTheme.Colors.surfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
            .shadow(color: Color(hex: "#8C634F").opacity(0.07), radius: 10, y: 3)

            // Save Button
            Button(action: { onSaveToggle?() }) {
                Image(systemName: item.isSaved ? "heart.fill" : "heart")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(item.isSaved ? .red : AppTheme.Colors.onSurfaceVariant)
                    .frame(width: 32, height: 32)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .padding(8)
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    var accentColor: Color = AppTheme.Colors.primary

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(accentColor)
            }
            Text(value)
                .font(AppTheme.Typography.headlineMd)
                .foregroundStyle(AppTheme.Colors.onSurface)
            Text(label)
                .font(AppTheme.Typography.labelSm)
                .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(AppTheme.Colors.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
        .shadow(color: Color(hex: "#8C634F").opacity(0.07), radius: 10, y: 3)
    }
}

// MARK: - Furniture Recommendation Card
struct RecommendationCard: View {
    let item: FurnitureItem

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                    .fill(item.accentColor.opacity(0.2))
                    .frame(width: 68, height: 68)
                Image(systemName: item.category.icon)
                    .font(.system(size: 28, weight: .light))
                    .foregroundStyle(item.accentColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.name)
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(AppTheme.Colors.onSurface)
                        .lineLimit(1)
                    Spacer()
                    if item.isRecommended {
                        Image(systemName: "sparkles")
                            .font(.system(size: 12))
                            .foregroundStyle(AppTheme.Colors.primary)
                    }
                }

                Text(item.brand)
                    .font(AppTheme.Typography.labelSm)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)

                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.orange)
                        Text(String(format: "%.1f", item.rating))
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }
                    Spacer()
                    Text(item.formattedPrice)
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(AppTheme.Colors.primary)
                }
            }
        }
        .padding(16)
        .background(AppTheme.Colors.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
        .shadow(color: Color(hex: "#8C634F").opacity(0.07), radius: 10, y: 3)
    }
}

// MARK: - AI Processing Card
struct AIProcessingCard: View {
    let step: String
    let isActive: Bool
    let isComplete: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(isComplete ? AppTheme.Colors.primary : isActive ? AppTheme.Colors.primaryContainer : AppTheme.Colors.surfaceContainer)
                    .frame(width: 36, height: 36)

                if isComplete {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                } else if isActive {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.7)
                        .tint(AppTheme.Colors.primary)
                } else {
                    Circle()
                        .fill(AppTheme.Colors.outlineVariant)
                        .frame(width: 10, height: 10)
                }
            }

            Text(step)
                .font(AppTheme.Typography.bodyMd)
                .foregroundStyle(
                    isActive ? AppTheme.Colors.onSurface :
                    isComplete ? AppTheme.Colors.primary :
                    AppTheme.Colors.onSurfaceVariant
                )
                .fontWeight(isActive ? .semibold : .regular)

            Spacer()
        }
        .padding(16)
        .background(
            isActive ? AppTheme.Colors.primaryContainer.opacity(0.4) : AppTheme.Colors.surfaceContainerLowest
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.large))
    }
}
