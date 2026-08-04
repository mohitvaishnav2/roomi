import SwiftUI

// MARK: - Home View (Screen 07)
struct HomeView: View {
    @EnvironmentObject private var auth: AuthManager
    @Environment(NavigationRouter.self) private var router
    @State private var scrollOffset: CGFloat = 0

    private let greeting: String = {
        let hour = Calendar.current.component(.hour, from: .now)
        return hour < 12 ? "Good morning" : hour < 17 ? "Good afternoon" : "Good evening"
    }()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 32, pinnedViews: []) {
                // Hero Section
                heroSection

                // Quick Actions
                quickActions

                // Recent Projects
                recentProjects

                // Explore Styles
                exploreStyles

                // AI Tip Banner
                aiTipBanner
            }
            .padding(.bottom, 100)
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationBarHidden(true)
        .safeAreaInset(edge: .top) { topBar }
        .scrollIndicators(.hidden)
    }

    // MARK: Top Bar
    private var topBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(AppTheme.Typography.labelMd)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                Text(auth.currentUser?.name.components(separatedBy: " ").first ?? "Designer")
                    .font(AppTheme.Typography.headlineMd)
                    .foregroundStyle(AppTheme.Colors.secondary)
            }
            Spacer()
            HStack(spacing: 8) {
                IconButton(icon: "bell") { router.push(.notifications) }
                Button { router.push(.profile) } label: {
                    Circle()
                        .fill(AppTheme.Colors.primaryContainer)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundStyle(AppTheme.Colors.primary)
                                .font(.system(size: 16))
                        )
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }

    // MARK: Hero Editorial Card
    private var heroSection: some View {
        Button { router.push(.scanPrep) } label: {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [Color(hex: "#4A2C17"), Color(hex: "#715950"), Color(hex: "#DFC0B5")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 320)
                .overlay(
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "sofa")
                                .font(.system(size: 80, weight: .ultraLight))
                                .foregroundStyle(.white.opacity(0.12))
                                .padding(24)
                        }
                        Spacer()
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))

                VStack(alignment: .leading, spacing: 10) {
                    Label("Getting Started", systemImage: "sparkles")
                        .font(AppTheme.Typography.labelSm)
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.15), in: Capsule())

                    Text("Design your\nfirst room")
                        .font(AppTheme.Typography.headlineLgMobile)
                        .foregroundStyle(.white)

                    Text("Map your space instantly and explore AI-curated arrangements.")
                        .font(AppTheme.Typography.bodyMd)
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(2)

                    Label("Scan a Room", systemImage: "camera.viewfinder")
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 11)
                        .background(AppTheme.Colors.primary, in: Capsule())
                        .padding(.top, 4)
                }
                .padding(24)
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal, 16)
    }

    // MARK: Quick Actions
    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Quick Actions")
                .padding(.horizontal, 24)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                QuickActionItem(icon: "camera", label: "Scan Room", color: AppTheme.Colors.primary) { router.push(.scanPrep) }
                QuickActionItem(icon: "safari", label: "Explore Ideas", color: AppTheme.Colors.tertiary) { router.push(.explore) }
                QuickActionItem(icon: "sparkles", label: "AI Design", color: Color(hex: "#8B7355")) { router.push(.aiDesignBrief) }
                QuickActionItem(icon: "folder", label: "Projects", color: AppTheme.Colors.secondary) { router.push(.projects) }
                QuickActionItem(icon: "heart", label: "Saved", color: Color.pink) { router.push(.savedInspirations) }
                QuickActionItem(icon: "cube.transparent", label: "AR Place", color: Color(hex: "#5B8DB8")) { router.push(.arPlacement) }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: Recent Projects
    private var recentProjects: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(
                title: "Recent Projects",
                action: ("See All", { router.push(.projects) })
            )
            .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {
                    ForEach(RoomProject.sampleProjects.prefix(3)) { project in
                        RoomCard(project: project) { router.push(.projectDetails(projectID: project.id)) }
                            .frame(width: 220)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: Explore Styles
    private var exploreStyles: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(
                title: "Explore Styles",
                action: ("Browse All", { router.push(.explore) })
            )
            .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(DesignStyle.allCases.prefix(5)) { style in
                        StyleCard(style: style) { router.push(.styleSelection) }
                            .frame(width: 150)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: AI Tip Banner
    private var aiTipBanner: some View {
        HStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(AppTheme.Colors.primary)
                .frame(width: 48, height: 48)
                .background(AppTheme.Colors.primaryContainer, in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text("AI Tip")
                    .font(AppTheme.Typography.labelMd)
                    .foregroundStyle(AppTheme.Colors.primary)
                Text("Scan in natural daylight for best spatial accuracy.")
                    .font(AppTheme.Typography.bodyMd)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    .lineLimit(2)
            }
        }
        .padding(20)
        .background(AppTheme.Colors.primaryContainer.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
        .padding(.horizontal, 16)
    }
}

// MARK: - Quick Action Item
private struct QuickActionItem: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 52, height: 52)
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(color)
                }
                Text(label)
                    .font(AppTheme.Typography.labelSm)
                    .foregroundStyle(AppTheme.Colors.onSurface)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppTheme.Colors.surfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
            .shadow(color: Color(hex: "#8C634F").opacity(0.07), radius: 10, y: 3)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(AuthManager())
            .environment(NavigationRouter())
    }
}
