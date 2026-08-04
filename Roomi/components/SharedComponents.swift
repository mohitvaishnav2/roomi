import SwiftUI

// MARK: - Page Indicator
struct PageIndicator: View {
    let count: Int
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index == current ? AppTheme.Colors.primary : AppTheme.Colors.surfaceVariant)
                    .frame(width: index == current ? 20 : 7, height: 7)
                    .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: current)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Page \(current + 1) of \(count)")
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var action: (title: String, handler: () -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTheme.Typography.headlineMd)
                    .foregroundStyle(AppTheme.Colors.onSurface)
                if let subtitle {
                    Text(subtitle)
                        .font(AppTheme.Typography.bodyMd)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                }
            }
            Spacer()
            if let action {
                Button(action.handler) {
                    Text(action.title)
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(AppTheme.Colors.primary)
                }
            }
        }
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    var icon: String? = nil
    var isSelected: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .semibold))
                }
                Text(title)
                    .font(AppTheme.Typography.labelSm)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .foregroundStyle(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.onSurfaceVariant)
            .background(isSelected ? AppTheme.Colors.primaryContainer : AppTheme.Colors.surfaceContainer)
            .clipShape(Capsule())
            .overlay(
                Capsule().strokeBorder(
                    isSelected ? AppTheme.Colors.primary.opacity(0.5) : Color.clear,
                    lineWidth: 1
                )
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    var action: (label: String, handler: () -> Void)? = nil

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.primaryContainer.opacity(0.4))
                    .frame(width: 88, height: 88)
                Image(systemName: icon)
                    .font(.system(size: 36, weight: .ultraLight))
                    .foregroundStyle(AppTheme.Colors.primary.opacity(0.6))
            }

            VStack(spacing: 8) {
                Text(title)
                    .font(AppTheme.Typography.headlineMd)
                    .foregroundStyle(AppTheme.Colors.onSurface)
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .font(AppTheme.Typography.bodyMd)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    .multilineTextAlignment(.center)
            }

            if let action {
                SecondaryButton(action.label, action: action.handler)
                    .fixedSize()
            }
            Spacer()
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Loading Card
struct LoadingCard: View {
    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: AppTheme.Radius.xl)
            .fill(AppTheme.Colors.surfaceContainer)
            .opacity(isAnimating ? 0.5 : 1.0)
            .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear { isAnimating = true }
    }
}

// MARK: - Privacy Badge
struct PrivacyBadge: View {
    let label: String
    var icon: String = "lock.fill"

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(label)
                .font(AppTheme.Typography.labelSm)
        }
        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .background(AppTheme.Colors.surfaceContainer, in: Capsule())
    }
}

// MARK: - Toast View
struct ToastView: View {
    let message: String
    var icon: String = "checkmark.circle.fill"
    var isError: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(isError ? AppTheme.Colors.error : AppTheme.Colors.tertiary)
            Text(message)
                .font(AppTheme.Typography.labelMd)
                .foregroundStyle(AppTheme.Colors.onSurface)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial, in: Capsule())
        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
    }
}

// MARK: - Offline Banner
struct OfflineBanner: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 14, weight: .semibold))
            Text("You're offline — some features are unavailable")
                .font(AppTheme.Typography.labelSm)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "#4A4A4A"))
    }
}

// MARK: - Permission Card
struct PermissionCard: View {
    let icon: String
    let title: String
    let description: String
    var onAllow: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.primaryContainer)
                    .frame(width: 72, height: 72)
                Image(systemName: icon)
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(AppTheme.Colors.primary)
            }

            VStack(spacing: 6) {
                Text(title)
                    .font(AppTheme.Typography.headlineMd)
                    .foregroundStyle(AppTheme.Colors.onSurface)
                    .multilineTextAlignment(.center)
                Text(description)
                    .font(AppTheme.Typography.bodyMd)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    .multilineTextAlignment(.center)
            }

            if let onAllow {
                PrimaryButton("Allow Access", icon: "checkmark", action: onAllow)
            }
        }
        .padding(24)
        .background(AppTheme.Colors.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
        .shadow(color: Color(hex: "#8C634F").opacity(0.09), radius: 20, y: 6)
    }
}

// MARK: - Notification Row
struct NotificationRow: View {
    let notification: AppNotification

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(notification.type.color.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: notification.type.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(notification.type.color)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(AppTheme.Colors.onSurface)
                        .lineLimit(1)
                    Spacer()
                    if !notification.isRead {
                        Circle()
                            .fill(AppTheme.Colors.primary)
                            .frame(width: 8, height: 8)
                    }
                }
                Text(notification.body)
                    .font(AppTheme.Typography.bodyMd)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    .lineLimit(2)
                Text(notification.date.formatted(.relative(presentation: .named)))
                    .font(AppTheme.Typography.labelSm)
                    .foregroundStyle(AppTheme.Colors.outline)
            }
        }
        .padding(16)
        .background(
            notification.isRead ? AppTheme.Colors.surfaceContainerLowest : AppTheme.Colors.primaryContainer.opacity(0.2)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
    }
}

// MARK: - Measurement Row
struct MeasurementRow: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(AppTheme.Colors.primary)
                .frame(width: 24)
            Text(label)
                .font(AppTheme.Typography.bodyMd)
                .foregroundStyle(AppTheme.Colors.onSurface)
            Spacer()
            Text(value)
                .font(AppTheme.Typography.labelMd)
                .foregroundStyle(AppTheme.Colors.primary)
        }
        .padding(.vertical, 12)
    }
}
