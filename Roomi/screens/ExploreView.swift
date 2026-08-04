import SwiftUI

// MARK: - Explore View (Screen 08)
struct ExploreView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var selectedCategory: DesignStyle? = nil
    @State private var searchText = ""

    private var filteredItems: [InspirationItem] {
        var items = InspirationItem.sampleItems
        if let cat = selectedCategory { items = items.filter { $0.style == cat } }
        if !searchText.isEmpty { items = items.filter { $0.title.localizedCaseInsensitiveContains(searchText) } }
        return items
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24, pinnedViews: [.sectionHeaders]) {
                Section {
                    // Category Chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            CategoryChip(title: "All", isSelected: selectedCategory == nil) {
                                withAnimation { selectedCategory = nil }
                            }
                            ForEach(DesignStyle.allCases) { style in
                                CategoryChip(title: style.rawValue, icon: style.icon, isSelected: selectedCategory == style) {
                                    withAnimation { selectedCategory = selectedCategory == style ? nil : style }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // Featured Banner
                    featuredBanner

                    // Grid
                    if filteredItems.isEmpty {
                        EmptyStateView(
                            icon: "safari",
                            title: "No results",
                            subtitle: "Try a different style or clear your filters."
                        )
                        .frame(height: 300)
                    } else {
                        LazyVGrid(
                            columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                            spacing: 12
                        ) {
                            ForEach(filteredItems) { item in
                                InspirationCard(item: item)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                } header: {
                    // Sticky Search Bar
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        TextField("Search styles, rooms...", text: $searchText)
                            .font(AppTheme.Typography.bodyMd)
                        if !searchText.isEmpty {
                            Button { searchText = "" } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(AppTheme.Colors.surfaceContainer, in: RoundedRectangle(cornerRadius: AppTheme.Radius.full))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                }
            }
            .padding(.bottom, 100)
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.large)
        .scrollIndicators(.hidden)
    }

    private var featuredBanner: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color(hex: "#5B6147"), Color(hex: "#8B9467"), Color(hex: "#DBE1C0")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 180)
            .overlay(
                Image(systemName: "leaf")
                    .font(.system(size: 80, weight: .ultraLight))
                    .foregroundStyle(.white.opacity(0.1))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(16)
            )
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))

            VStack(alignment: .leading, spacing: 6) {
                Label("Editor's Pick", systemImage: "star.fill")
                    .font(AppTheme.Typography.labelSm)
                    .foregroundStyle(.white.opacity(0.8))
                Text("Japandi: The Art of\nCalm Living")
                    .font(AppTheme.Typography.headlineMd)
                    .foregroundStyle(.white)
                    .lineLimit(2)
            }
            .padding(20)
        }
        .padding(.horizontal, 16)
        .shadow(color: Color(hex: "#8C634F").opacity(0.1), radius: 16, y: 6)
    }
}

#Preview {
    NavigationStack {
        ExploreView()
            .environment(NavigationRouter())
    }
}
