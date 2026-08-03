import SwiftUI

// MARK: - App Tab Enum
enum AppTab: Int, CaseIterable {
    case home, explore, scan, projects, profile
}

// MARK: - Root Navigation Hub
struct ContentView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        Group {
            if auth.isLoggedIn {
                MainTabView()
            } else {
                NavigationStack {
                    WelcomeView()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: auth.isLoggedIn)
    }
}


// MARK: - Main Tab View
struct MainTabView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            // ── Content ──────────────────────────────────────
            Group {
                switch selectedTab {
                case .home:     HomeView()
                case .explore:  ComingSoonView(title: "Explore",  icon: "safari")
                case .scan:     RoomScannerView()
                case .projects: ComingSoonView(title: "Projects", icon: "folder")
                case .profile:  ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // ── Custom Tab Bar ────────────────────────────────
            MainTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Custom Tab Bar
struct MainTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        ZStack(alignment: .top) {
            // Floating FAB (sits above the bar)
            HStack {
                Spacer()
                scanFAB
                Spacer()
            }
            .offset(y: -26)
            .zIndex(2)

            // Bar
            HStack(spacing: 0) {
                tabItem(.home,     "house",    "house.fill",   "Home")
                tabItem(.explore,  "safari",   "safari",       "Explore")

                // FAB placeholder space
                Color.clear.frame(width: 80, height: 60)

                tabItem(.projects, "folder",   "folder.fill",  "Projects")
                tabItem(.profile,  "person",   "person.fill",  "Profile")
            }
            .frame(height: 62)
            .padding(.horizontal, 8)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea(edges: .bottom)
                    .shadow(color: Color(hex: "#8C634F").opacity(0.09), radius: 28, x: 0, y: -6)
            )
            .zIndex(1)
        }
    }

    // MARK: FAB
    private var scanFAB: some View {
        Button { selectedTab = .scan } label: {
            ZStack {
                // Surface-coloured ring so it "punches" through the bar
                Circle()
                    .fill(Color(UIColor.systemBackground))
                    .frame(width: 66, height: 66)

                Circle()
                    .fill(AppTheme.Colors.primary)
                    .frame(width: 56, height: 56)
                    .shadow(color: AppTheme.Colors.primary.opacity(0.45), radius: 16, y: 4)

                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(selectedTab == .scan ? 1.08 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.65), value: selectedTab == .scan)
    }

    // MARK: Tab Item
    @ViewBuilder
    private func tabItem(_ tab: AppTab, _ icon: String, _ activeIcon: String, _ label: String) -> some View {
        let active = selectedTab == tab
        Button { withAnimation(.spring(response: 0.25)) { selectedTab = tab } } label: {
            VStack(spacing: 3) {
                Image(systemName: active ? activeIcon : icon)
                    .font(.system(size: 20))
                    .foregroundColor(active ? AppTheme.Colors.primary : AppTheme.Colors.onSurfaceVariant.opacity(0.55))
                Text(label)
                    .font(.custom("PlusJakartaSans-Medium", size: 11))
                    .foregroundColor(active ? AppTheme.Colors.primary : AppTheme.Colors.onSurfaceVariant.opacity(0.55))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(active ? AppTheme.Colors.primaryContainer.opacity(0.4) : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Coming-Soon Placeholder
struct ComingSoonView: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 52, weight: .ultraLight))
                .foregroundColor(AppTheme.Colors.primary.opacity(0.25))
            Text(title)
                .font(AppTheme.Typography.headlineMd)
                .foregroundColor(AppTheme.Colors.primary)
            Text("Coming Soon")
                .font(AppTheme.Typography.bodyMd)
                .foregroundColor(AppTheme.Colors.onSurfaceVariant)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.surface.ignoresSafeArea())
    }
}

#Preview {
    ContentView()
}
