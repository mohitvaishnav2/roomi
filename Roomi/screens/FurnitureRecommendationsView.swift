import SwiftUI

// MARK: - Furniture Recommendations View (Screen 19)
struct FurnitureRecommendationsView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var selectedCategory: FurnitureItem.FurnitureCategory? = nil
    @State private var savedItems: Set<String> = []
    @State private var cartItems: Set<String> = []

    private var filteredItems: [FurnitureItem] {
        guard let cat = selectedCategory else { return FurnitureItem.sampleItems }
        return FurnitureItem.sampleItems.filter { $0.category == cat }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                Section {
                    // Budget Summary
                    budgetSummary

                    // Items List
                    LazyVStack(spacing: 12) {
                        ForEach(filteredItems) { item in
                            FurnitureItemCard(
                                item: item,
                                isSaved: savedItems.contains(item.id),
                                isInCart: cartItems.contains(item.id),
                                onSave: {
                                    withAnimation {
                                        if savedItems.contains(item.id) { savedItems.remove(item.id) }
                                        else { savedItems.insert(item.id) }
                                    }
                                },
                                onAddToCart: {
                                    withAnimation {
                                        if cartItems.contains(item.id) { cartItems.remove(item.id) }
                                        else { cartItems.insert(item.id) }
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)

                    if !cartItems.isEmpty {
                        VStack(spacing: 8) {
                            PrimaryButton("View Shortlist (\(cartItems.count))", icon: "list.bullet") {}
                            SecondaryButton("Try in AR", icon: "cube.transparent") {
                                router.push(.arPlacement)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                } header: {
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            CategoryChip(title: "All", isSelected: selectedCategory == nil) {
                                withAnimation { selectedCategory = nil }
                            }
                            ForEach(FurnitureItem.FurnitureCategory.allCases) { cat in
                                CategoryChip(title: cat.rawValue, icon: cat.icon, isSelected: selectedCategory == cat) {
                                    withAnimation { selectedCategory = selectedCategory == cat ? nil : cat }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                }
            }
            .padding(.bottom, 100)
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Furniture Picks")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !cartItems.isEmpty {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "list.bullet.clipboard")
                            .foregroundStyle(AppTheme.Colors.primary)
                        Circle()
                            .fill(AppTheme.Colors.primary)
                            .frame(width: 14, height: 14)
                            .overlay(
                                Text("\(cartItems.count)")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white)
                            )
                            .offset(x: 6, y: -6)
                    }
                }
            }
        }
    }

    private var budgetSummary: some View {
        HStack(spacing: 0) {
            VStack(spacing: 2) {
                Text("$3,236")
                    .font(AppTheme.Typography.headlineMd)
                    .foregroundStyle(AppTheme.Colors.onSurface)
                Text("Total est.")
                    .font(AppTheme.Typography.labelSm)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
            }
            .frame(maxWidth: .infinity)

            Divider().frame(height: 36)

            VStack(spacing: 2) {
                Text("\(FurnitureItem.sampleItems.count)")
                    .font(AppTheme.Typography.headlineMd)
                    .foregroundStyle(AppTheme.Colors.onSurface)
                Text("Items")
                    .font(AppTheme.Typography.labelSm)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
            }
            .frame(maxWidth: .infinity)

            Divider().frame(height: 36)

            VStack(spacing: 2) {
                Text("96%")
                    .font(AppTheme.Typography.headlineMd)
                    .foregroundStyle(AppTheme.Colors.tertiary)
                Text("Fit Score")
                    .font(AppTheme.Typography.labelSm)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 16)
        .background(AppTheme.Colors.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
        .shadow(color: Color(hex: "#8C634F").opacity(0.07), radius: 10, y: 3)
        .padding(.horizontal, 16)
    }
}

// MARK: - Furniture Item Card
private struct FurnitureItemCard: View {
    let item: FurnitureItem
    let isSaved: Bool
    let isInCart: Bool
    let onSave: () -> Void
    let onAddToCart: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                    .fill(item.accentColor.opacity(0.18))
                    .frame(width: 72, height: 72)
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
                    if item.isRecommended {
                        Image(systemName: "sparkles")
                            .font(.system(size: 11))
                            .foregroundStyle(AppTheme.Colors.primary)
                    }
                    Spacer()
                    Button(action: onSave) {
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                            .font(.system(size: 14))
                            .foregroundStyle(isSaved ? .red : AppTheme.Colors.onSurfaceVariant)
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

                Button(action: onAddToCart) {
                    Label(isInCart ? "Remove" : "Add to List", systemImage: isInCart ? "checkmark" : "plus")
                        .font(AppTheme.Typography.labelSm)
                        .foregroundStyle(isInCart ? AppTheme.Colors.tertiary : AppTheme.Colors.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(
                            isInCart ? AppTheme.Colors.tertiaryContainer.opacity(0.5) : AppTheme.Colors.primaryContainer
                        )
                        .clipShape(Capsule())
                }
            }
        }
        .padding(14)
        .background(AppTheme.Colors.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
        .shadow(color: Color(hex: "#8C634F").opacity(0.07), radius: 10, y: 3)
    }
}

#Preview {
    NavigationStack {
        FurnitureRecommendationsView()
            .environment(NavigationRouter())
    }
}
