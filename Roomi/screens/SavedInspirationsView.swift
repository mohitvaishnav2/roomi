import SwiftUI

// MARK: - Saved Inspirations View (Screen 24)
struct SavedInspirationsView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var savedItems = InspirationItem.sampleItems.filter { $0.isSaved }
    @State private var selectedStyle: DesignStyle? = nil

    private var filteredItems: [InspirationItem] {
        guard let style = selectedStyle else { return savedItems }
        return savedItems.filter { $0.style == style }
    }

    var body: some View {
        Group {
            if savedItems.isEmpty {
                EmptyStateView(
                    icon: "heart",
                    title: "No saved inspirations",
                    subtitle: "Explore styles and save rooms you love.",
                    action: ("Explore Now", { router.push(.explore) })
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                CategoryChip(title: "All", isSelected: selectedStyle == nil) {
                                    withAnimation { selectedStyle = nil }
                                }
                                ForEach(Set(savedItems.map { $0.style }).sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { style in
                                    CategoryChip(title: style.rawValue, isSelected: selectedStyle == style) {
                                        withAnimation { selectedStyle = selectedStyle == style ? nil : style }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }

                        // Grid
                        LazyVGrid(
                            columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                            spacing: 12
                        ) {
                            ForEach(filteredItems) { item in
                                InspirationCard(item: item) {
                                    withAnimation {
                                        savedItems.removeAll { $0.id == item.id }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .animation(.interactiveSpring(), value: filteredItems.map { $0.id })
                    }
                    .padding(.vertical, 16)
                    .padding(.bottom, 100)
                }
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Saved (\(savedItems.count))")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        SavedInspirationsView()
            .environment(NavigationRouter())
    }
}
