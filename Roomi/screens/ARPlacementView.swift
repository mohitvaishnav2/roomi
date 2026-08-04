import SwiftUI

// MARK: - AR Placement View (Screen 20)
struct ARPlacementView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var placedItems: [PlacedItem] = []
    @State private var selectedFurniture = 0
    @State private var isPlacingMode = true
    @State private var showPrivacyBanner = true

    private let furnitureOptions = [
        ("sofa", "Sofa", AppTheme.Colors.primary),
        ("table.furniture", "Coffee Table", AppTheme.Colors.secondary),
        ("chair", "Chair", AppTheme.Colors.tertiary),
        ("lamp.floor", "Floor Lamp", Color(hex: "#8B7355")),
    ]

    var body: some View {
        ZStack {
            // Simulated AR View
            LinearGradient(
                colors: [Color(hex: "#87CEEB"), Color(hex: "#B0E0E6"), Color(hex: "#E8DDD0")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Grid Floor Plane
            Canvas { context, size in
                let rows = 8, cols = 12
                let cellW = size.width / CGFloat(cols)
                let cellH = size.height * 0.4 / CGFloat(rows)
                let floorTop = size.height * 0.55

                context.opacity = 0.25
                for r in 0...rows {
                    var path = Path()
                    path.move(to: CGPoint(x: 0, y: floorTop + cellH * CGFloat(r)))
                    path.addLine(to: CGPoint(x: size.width, y: floorTop + cellH * CGFloat(r)))
                    context.stroke(path, with: .color(.white), lineWidth: 0.5)
                }
                for c in 0...cols {
                    var path = Path()
                    path.move(to: CGPoint(x: cellW * CGFloat(c), y: floorTop))
                    path.addLine(to: CGPoint(x: cellW * CGFloat(c), y: size.height))
                    context.stroke(path, with: .color(.white), lineWidth: 0.5)
                }
            }
            .ignoresSafeArea()

            // Placed Items
            ForEach(placedItems) { item in
                ZStack {
                    Ellipse()
                        .fill(.black.opacity(0.1))
                        .frame(width: 60, height: 16)
                        .offset(y: 28)
                    Image(systemName: item.icon)
                        .font(.system(size: 36, weight: .light))
                        .foregroundStyle(item.color)
                        .shadow(radius: 4)
                }
                .position(item.position)
                .transition(.scale.combined(with: .opacity))
            }

            // Placement Reticle
            if isPlacingMode {
                ZStack {
                    Ellipse()
                        .stroke(AppTheme.Colors.primary.opacity(0.7), lineWidth: 2)
                        .frame(width: 80, height: 30)
                    Ellipse()
                        .stroke(AppTheme.Colors.primary.opacity(0.3), lineWidth: 1)
                        .frame(width: 100, height: 38)
                }
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.65)
            }

            // Privacy Indicator
            if showPrivacyBanner {
                HStack {
                    HStack(spacing: 6) {
                        Circle().fill(.green).frame(width: 7, height: 7)
                        Text("Camera Active — Room data stays on-device")
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial, in: Capsule())

                    Spacer()

                    Button { withAnimation { showPrivacyBanner = false } } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .frame(maxHeight: .infinity, alignment: .top)
            }

            // Top Controls
            VStack {
                HStack {
                    Button {
                        router.pop()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    Spacer()
                    HStack(spacing: 8) {
                        Button {
                            withAnimation { placedItems.removeAll() }
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, showPrivacyBanner ? 60 : 16)
                Spacer()
            }

            // Bottom Panel
            VStack {
                Spacer()
                VStack(spacing: 16) {
                    // Furniture selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(furnitureOptions.indices, id: \.self) { idx in
                                let option = furnitureOptions[idx]
                                Button { selectedFurniture = idx } label: {
                                    VStack(spacing: 6) {
                                        ZStack {
                                            Circle()
                                                .fill(selectedFurniture == idx ? option.2 : .white.opacity(0.3))
                                                .frame(width: 52, height: 52)
                                            Image(systemName: option.0)
                                                .font(.system(size: 20))
                                                .foregroundStyle(selectedFurniture == idx ? .white : .white.opacity(0.7))
                                        }
                                        Text(option.1)
                                            .font(AppTheme.Typography.labelSm)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // Place button
                    PrimaryButton("Place Here", icon: "plus") {
                        let option = furnitureOptions[selectedFurniture]
                        let newItem = PlacedItem(
                            id: UUID().uuidString,
                            icon: option.0,
                            color: option.2,
                            position: CGPoint(
                                x: CGFloat.random(in: 100...300),
                                y: CGFloat.random(in: 480...580)
                            )
                        )
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            placedItems.append(newItem)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
        .navigationBarHidden(true)
        .statusBarHidden()
    }
}

// MARK: - Placed Item Model
private struct PlacedItem: Identifiable {
    let id: String
    let icon: String
    let color: Color
    let position: CGPoint
}

#Preview {
    NavigationStack {
        ARPlacementView()
            .environment(NavigationRouter())
    }
}
