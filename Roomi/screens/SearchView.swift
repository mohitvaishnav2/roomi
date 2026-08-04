import SwiftUI

// MARK: - Search View (Screen 09)
struct SearchView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var searchText = ""
    @State private var selectedScope: SearchScope = .all
    @FocusState private var isSearchFocused: Bool

    enum SearchScope: String, CaseIterable {
        case all = "All"
        case styles = "Styles"
        case projects = "Projects"
        case furniture = "Furniture"
    }

    private var recentSearches = ["Scandinavian living room", "Modern bedroom", "Industrial loft", "Japandi"]

    private var results: [SearchResult] {
        guard !searchText.isEmpty else { return [] }
        return SearchResult.sample.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(isSearchFocused ? AppTheme.Colors.primary : AppTheme.Colors.onSurfaceVariant)
                    .animation(.easeInOut(duration: 0.2), value: isSearchFocused)

                TextField("Rooms, styles, furniture...", text: $searchText)
                    .font(AppTheme.Typography.bodyMd)
                    .focused($isSearchFocused)
                    .submitLabel(.search)
                    .autocorrectionDisabled()

                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background(AppTheme.Colors.surfaceContainer, in: RoundedRectangle(cornerRadius: AppTheme.Radius.full))
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .animation(.interactiveSpring(), value: searchText.isEmpty)

            // Scope Picker
            Picker("Scope", selection: $selectedScope) {
                ForEach(SearchScope.allCases, id: \.self) { scope in
                    Text(scope.rawValue).tag(scope)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Divider()

            ScrollView {
                LazyVStack(spacing: 0) {
                    if searchText.isEmpty {
                        // Recent + Trending
                        recentSection
                        trendingSection
                    } else if results.isEmpty {
                        ContentUnavailableView(
                            "No Results",
                            systemImage: "magnifyingglass",
                            description: Text("Try a different search term.")
                        )
                        .padding(.top, 60)
                    } else {
                        resultsSection
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .onAppear { isSearchFocused = true }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Recent Searches",
                          action: ("Clear", {}))
                .padding(.horizontal, 16)
                .padding(.top, 20)

            ForEach(recentSearches, id: \.self) { term in
                Button { searchText = term } label: {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                            .frame(width: 20)
                        Text(term)
                            .font(AppTheme.Typography.bodyMd)
                            .foregroundStyle(AppTheme.Colors.onSurface)
                        Spacer()
                        Image(systemName: "arrow.up.left")
                            .font(.system(size: 12))
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
        }
    }

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Trending Now")
                .padding(.horizontal, 16)
                .padding(.top, 28)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(DesignStyle.allCases.prefix(6)) { style in
                        Button { searchText = style.rawValue } label: {
                            HStack(spacing: 6) {
                                Image(systemName: style.icon)
                                Text(style.rawValue)
                                    .font(AppTheme.Typography.labelMd)
                            }
                            .foregroundStyle(AppTheme.Colors.primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background(AppTheme.Colors.primaryContainer)
                            .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private var resultsSection: some View {
        LazyVStack(spacing: 1) {
            ForEach(results) { result in
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                            .fill(result.color.opacity(0.12))
                            .frame(width: 52, height: 52)
                        Image(systemName: result.icon)
                            .font(.system(size: 22, weight: .light))
                            .foregroundStyle(result.color)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(result.title)
                            .font(AppTheme.Typography.labelMd)
                            .foregroundStyle(AppTheme.Colors.onSurface)
                        Text(result.subtitle)
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.outlineVariant)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                Divider().padding(.leading, 82)
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Search Result Model
private struct SearchResult: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    static let sample: [SearchResult] = [
        SearchResult(id: "1", title: "Scandinavian Living Room", subtitle: "Style Guide", icon: "leaf", color: AppTheme.Colors.tertiary),
        SearchResult(id: "2", title: "Modern Bedroom Ideas", subtitle: "14 inspirations", icon: "bed.double", color: AppTheme.Colors.primary),
        SearchResult(id: "3", title: "Japandi Kitchen", subtitle: "Style Guide", icon: "fork.knife", color: Color(hex: "#8B7355")),
        SearchResult(id: "4", title: "Industrial Home Office", subtitle: "7 inspirations", icon: "desktopcomputer", color: AppTheme.Colors.secondary),
        SearchResult(id: "5", title: "Bohemian Living Space", subtitle: "Style Guide", icon: "sparkles", color: Color(hex: "#C4603C")),
        SearchResult(id: "6", title: "Coastal Bathroom", subtitle: "9 inspirations", icon: "water.waves", color: Color(hex: "#5B8DB8")),
    ]
}

#Preview {
    NavigationStack {
        SearchView()
            .environment(NavigationRouter())
    }
}
