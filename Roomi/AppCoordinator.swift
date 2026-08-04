import SwiftUI

// MARK: - App Coordinator
/// Root coordinator: manages Splash → Onboarding → Auth → Main app flow.
struct AppCoordinator: View {
    @EnvironmentObject private var auth: AuthManager
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showSplash = true
    @State private var router = NavigationRouter()

    var body: some View {
        Group {
            if showSplash {
                SplashView {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)
            } else if auth.isAuthenticated {
                MainTabCoordinator()
                    .environment(router)
                    .transition(.opacity)
            } else if !hasCompletedOnboarding {
                OnboardingCoordinator(onComplete: {
                    hasCompletedOnboarding = true
                })
                .transition(.opacity)
            } else {
                AuthCoordinator()
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showSplash)
        .animation(.easeInOut(duration: 0.35), value: auth.isAuthenticated)
    }
}

// MARK: - Onboarding Coordinator
struct OnboardingCoordinator: View {
    let onComplete: () -> Void
    @State private var page = 0

    var body: some View {
        TabView(selection: $page) {
            Onboard1View(onContinue: { page = 1 }, onSkip: onComplete)
                .tag(0)
            Onboard2View(onBack: { page = 0 }, onContinue: { page = 2 }, onSkip: onComplete)
                .tag(1)
            Onboard3View(onBack: { page = 1 }, onGetStarted: onComplete)
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
}

// MARK: - Auth Coordinator
struct AuthCoordinator: View {
    @State private var showRegister = false

    var body: some View {
        NavigationStack {
            LoginView(onNavigateToRegister: { showRegister = true })
                .navigationDestination(isPresented: $showRegister) {
                    RegisterView(onBack: { showRegister = false })
                }
        }
    }
}

// MARK: - Main Tab Coordinator
struct MainTabCoordinator: View {
    @Environment(NavigationRouter.self) private var router
    @State private var selectedTab: MainTab = .home

    var body: some View {
        @Bindable var router = router

        ZStack(alignment: .bottom) {
            NavigationStack(path: $router.path) {
                Group {
                    switch selectedTab {
                    case .home:     HomeView()
                    case .explore:  ExploreView()
                    case .projects: ProjectsView()
                    case .profile:  ProfileView()
                    }
                }
                .navigationDestination(for: AppRoute.self) { route in
                    routeView(for: route)
                }
            }

            MainTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    private func routeView(for route: AppRoute) -> some View {
        switch route {
        case .explore:               ExploreView()
        case .search:                SearchView()
        case .scanPrep:              ScanPrepView()
        case .roomScanner:           RoomScannerView()
        case .scanReview:            ScanReviewView()
        case .aiDesignBrief:         AIDesignBriefView()
        case .aiProcessing:          AIProcessingView()
        case .aiResult:              AIResultView()
        case .beforeAfter:           BeforeAfterView()
        case .styleSelection:        StyleSelectionView()
        case .colorsMaterials:       ColorsMaterialsView()
        case .furnitureRecommendations: FurnitureRecommendationsView()
        case .arPlacement:           ARPlacementView()
        case .measurements:          MeasurementsView()
        case .projects:              ProjectsView()
        case .projectDetails(let id): ProjectDetailsView(projectID: id)
        case .savedInspirations:     SavedInspirationsView()
        case .notifications:         NotificationsView()
        case .premium:               PremiumView()
        case .profile:               ProfileView()
        case .editProfile:           EditProfileView()
        case .settings:              SettingsView()
        case .helpAbout:             HelpAboutView()
        default:                     EmptyView()
        }
    }
}

// MARK: - Main Tab
enum MainTab: Hashable {
    case home, explore, projects, profile
}

// MARK: - Main Tab Bar
struct MainTabBar: View {
    @Binding var selectedTab: MainTab
    @Environment(NavigationRouter.self) private var router

    private let items: [(tab: MainTab, icon: String, activeIcon: String, label: String)] = [
        (.home, "house", "house.fill", "Home"),
        (.explore, "safari", "safari.fill", "Explore"),
        (.projects, "folder", "folder.fill", "Projects"),
        (.profile, "person", "person.fill", "Profile"),
    ]

    var body: some View {
        ZStack(alignment: .top) {
            // FAB
            HStack {
                Spacer()
                FloatingScanButton { router.push(.scanPrep) }
                Spacer()
            }
            .offset(y: -28)
            .zIndex(2)

            // Tab Bar
            HStack(spacing: 0) {
                ForEach(items, id: \.tab) { item in
                    if item.tab == .explore {
                        // FAB Placeholder
                        Color.clear.frame(width: 80, height: 62)
                    }
                    tabItem(item.tab, icon: item.icon, activeIcon: item.activeIcon, label: item.label)
                }
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

    @ViewBuilder
    private func tabItem(_ tab: MainTab, icon: String, activeIcon: String, label: String) -> some View {
        let active = selectedTab == tab
        Button {
            withAnimation(.interactiveSpring(response: 0.25)) { selectedTab = tab }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: active ? activeIcon : icon)
                    .font(.system(size: 20))
                    .foregroundStyle(active ? AppTheme.Colors.primary : AppTheme.Colors.onSurfaceVariant.opacity(0.6))
                Text(label)
                    .font(AppTheme.Typography.labelSm)
                    .foregroundStyle(active ? AppTheme.Colors.primary : AppTheme.Colors.onSurfaceVariant.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                Capsule().fill(active ? AppTheme.Colors.primaryContainer.opacity(0.45) : Color.clear)
                    .animation(.interactiveSpring(response: 0.3), value: active)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}
