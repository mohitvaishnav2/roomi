import SwiftUI

// MARK: - Profile View (Screen 27)
struct ProfileView: View {
    @EnvironmentObject private var auth: AuthManager
    @Environment(NavigationRouter.self) private var router

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [AppTheme.Colors.primary, AppTheme.Colors.primaryContainer],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 88, height: 88)
                        Text(String(auth.currentUser?.name.prefix(1) ?? "A"))
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }

                    VStack(spacing: 4) {
                        Text(auth.currentUser?.name ?? "Designer")
                            .font(AppTheme.Typography.headlineMd)
                            .foregroundStyle(AppTheme.Colors.onSurface)
                        Text(auth.currentUser?.email ?? "")
                            .font(AppTheme.Typography.bodyMd)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        if let location = auth.currentUser?.location, !location.isEmpty {
                            Label(location, systemImage: "mappin")
                                .font(AppTheme.Typography.labelSm)
                                .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        }
                    }

                    Button { router.push(.editProfile) } label: {
                        Text("Edit Profile")
                            .font(AppTheme.Typography.labelMd)
                            .foregroundStyle(AppTheme.Colors.primary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(AppTheme.Colors.primaryContainer, in: Capsule())
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                .padding(.top, 16)

                // Stats
                HStack(spacing: 0) {
                    profileStat(value: "\(RoomProject.sampleProjects.count)", label: "Projects")
                    Divider().frame(height: 36)
                    profileStat(value: "\(InspirationItem.sampleItems.filter { $0.isSaved }.count)", label: "Saved")
                    Divider().frame(height: 36)
                    profileStat(value: "3", label: "Scans")
                }
                .padding(.vertical, 16)
                .background(AppTheme.Colors.surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
                .shadow(color: Color(hex: "#8C634F").opacity(0.07), radius: 10, y: 3)
                .padding(.horizontal, 16)

                // Premium Banner
                Button { router.push(.premium) } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(Color(hex: "#FFD700"))
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Upgrade to Premium")
                                .font(AppTheme.Typography.labelMd)
                                .foregroundStyle(.white)
                            Text("Unlimited scans, AR, and AI designs")
                                .font(AppTheme.Typography.labelSm)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .padding(20)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#2C1B0E"), Color(hex: "#5C3A1E")],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
                }
                .buttonStyle(ScaleButtonStyle())
                .padding(.horizontal, 16)
                .shadow(color: Color(hex: "#2C1B0E").opacity(0.3), radius: 12, y: 4)

                // Settings Menu
                VStack(spacing: 4) {
                    profileMenuSection(title: "Account", items: [
                        ("person.circle", "Edit Profile", { router.push(.editProfile) }),
                        ("bell", "Notifications", { router.push(.notifications) }),
                    ])
                    profileMenuSection(title: "Design", items: [
                        ("heart", "Saved Inspirations", { router.push(.savedInspirations) }),
                        ("folder", "My Projects", { router.push(.projects) }),
                    ])
                    profileMenuSection(title: "App", items: [
                        ("gear", "Settings", { router.push(.settings) }),
                        ("questionmark.circle", "Help & About", { router.push(.helpAbout) }),
                    ])

                    // Sign Out
                    Button {
                        auth.signOut()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.right.square")
                                .foregroundStyle(AppTheme.Colors.error)
                                .frame(width: 20)
                            Text("Sign Out")
                                .font(AppTheme.Typography.bodyMd)
                                .foregroundStyle(AppTheme.Colors.error)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(AppTheme.Colors.errorContainer.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.horizontal, 16)
                }

                Text("RoomIQ AI v1.0.0")
                    .font(AppTheme.Typography.labelSm)
                    .foregroundStyle(AppTheme.Colors.outline)
                    .padding(.bottom, 100)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private func profileStat(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(AppTheme.Typography.headlineMd)
                .foregroundStyle(AppTheme.Colors.onSurface)
            Text(label)
                .font(AppTheme.Typography.labelSm)
                .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func profileMenuSection(title: String, items: [(String, String, () -> Void)]) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .font(AppTheme.Typography.labelSm)
                .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { idx in
                    let item = items[idx]
                    Button(action: item.2) {
                        HStack(spacing: 14) {
                            Image(systemName: item.0)
                                .foregroundStyle(AppTheme.Colors.primary)
                                .frame(width: 22)
                            Text(item.1)
                                .font(AppTheme.Typography.bodyMd)
                                .foregroundStyle(AppTheme.Colors.onSurface)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(AppTheme.Colors.outlineVariant)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(ScaleButtonStyle())

                    if idx < items.count - 1 {
                        Divider().padding(.leading, 56)
                    }
                }
            }
            .background(AppTheme.Colors.surfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AuthManager())
            .environment(NavigationRouter())
    }
}
