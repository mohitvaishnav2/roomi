import SwiftUI

// MARK: - Measurements View (Screen 21)
struct MeasurementsView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var editMode = false
    @State private var width: Double = 5.2
    @State private var length: Double = 7.8
    @State private var height: Double = 2.7

    private var area: Double { width * length }
    private var volume: Double { width * length * height }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Room Diagram
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "#1A1A2E"), Color(hex: "#2C2C4A")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))

                    // Room box diagram
                    Canvas { context, size in
                        let cx = size.width / 2
                        let cy = size.height / 2

                        // Scale
                        let wScale = min(width / 10, 1.0)
                        let lScale = min(length / 10, 1.0)
                        let boxW = 110.0 * wScale + 50
                        let boxH = 80.0 * lScale + 40

                        // Front face
                        var front = Path(roundedRect: CGRect(x: cx - boxW/2, y: cy - boxH/2, width: boxW, height: boxH), cornerRadius: 4)
                        context.fill(front, with: .color(.white.opacity(0.05)))
                        context.stroke(front, with: .color(.white.opacity(0.5)), lineWidth: 1.5)

                        // Top face
                        var top = Path()
                        top.move(to: CGPoint(x: cx - boxW/2, y: cy - boxH/2))
                        top.addLine(to: CGPoint(x: cx - boxW/2 + 30, y: cy - boxH/2 - 20))
                        top.addLine(to: CGPoint(x: cx + boxW/2 + 30, y: cy - boxH/2 - 20))
                        top.addLine(to: CGPoint(x: cx + boxW/2, y: cy - boxH/2))
                        top.closeSubpath()
                        context.fill(top, with: .color(.white.opacity(0.08)))
                        context.stroke(top, with: .color(.white.opacity(0.4)), lineWidth: 1)

                        // Right face
                        var side = Path()
                        side.move(to: CGPoint(x: cx + boxW/2, y: cy - boxH/2))
                        side.addLine(to: CGPoint(x: cx + boxW/2 + 30, y: cy - boxH/2 - 20))
                        side.addLine(to: CGPoint(x: cx + boxW/2 + 30, y: cy + boxH/2 - 20))
                        side.addLine(to: CGPoint(x: cx + boxW/2, y: cy + boxH/2))
                        side.closeSubpath()
                        context.fill(side, with: .color(.white.opacity(0.04)))
                        context.stroke(side, with: .color(.white.opacity(0.3)), lineWidth: 1)

                        // Dimension labels
                        let wText = AttributedString("\(String(format: "%.1f", width)) m")
                        context.draw(Text(wText).font(.system(size: 11, design: .monospaced)).foregroundColor(.white.opacity(0.7)),
                                    at: CGPoint(x: cx, y: cy + boxH/2 + 14))

                        let hText = AttributedString("\(String(format: "%.1f", height)) m")
                        context.draw(Text(hText).font(.system(size: 11, design: .monospaced)).foregroundColor(.white.opacity(0.7)),
                                    at: CGPoint(x: cx + boxW/2 + 46, y: cy))
                    }
                }
                .padding(.horizontal, 16)
                .shadow(color: .black.opacity(0.2), radius: 16, y: 8)

                // Stats Row
                HStack(spacing: 12) {
                    StatCard(icon: "square", value: String(format: "%.1f m²", area), label: "Floor Area", accentColor: AppTheme.Colors.primary)
                    StatCard(icon: "cube", value: String(format: "%.1f m³", volume), label: "Volume", accentColor: AppTheme.Colors.tertiary)
                }
                .padding(.horizontal, 16)

                // Measurements Form
                VStack(spacing: 0) {
                    HStack {
                        SectionHeader(title: "Dimensions")
                        Spacer()
                        Button(editMode ? "Done" : "Edit") {
                            withAnimation { editMode.toggle() }
                        }
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(AppTheme.Colors.primary)
                    }
                    .padding(.bottom, 12)

                    Divider()
                    measurementSlider("Width", value: $width, range: 2...15, icon: "arrow.left.and.right")
                    Divider()
                    measurementSlider("Length", value: $length, range: 2...20, icon: "arrow.up.and.down")
                    Divider()
                    measurementSlider("Height", value: $height, range: 2...5, icon: "arrow.up.to.line")
                }
                .padding(20)
                .background(AppTheme.Colors.surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
                .shadow(color: Color(hex: "#8C634F").opacity(0.07), radius: 10, y: 3)
                .padding(.horizontal, 16)

                // AI Insight
                HStack(spacing: 14) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(AppTheme.Colors.primary)
                        .frame(width: 44, height: 44)
                        .background(AppTheme.Colors.primaryContainer, in: Circle())
                    VStack(alignment: .leading, spacing: 3) {
                        Text("AI Insight")
                            .font(AppTheme.Typography.labelMd)
                            .foregroundStyle(AppTheme.Colors.primary)
                        Text("Your \(String(format: "%.0f", area)) m² room supports a sectional sofa up to 3.2 m wide with optimal traffic flow.")
                            .font(AppTheme.Typography.bodyMd)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                            .lineLimit(3)
                    }
                }
                .padding(16)
                .background(AppTheme.Colors.primaryContainer.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
                .padding(.horizontal, 16)

                PrimaryButton("Use These Measurements") { router.pop() }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Room Measurements")
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private func measurementSlider(_ label: String, value: Binding<Double>, range: ClosedRange<Double>, icon: String) -> some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(AppTheme.Colors.primary)
                    .frame(width: 20)
                Text(label)
                    .font(AppTheme.Typography.bodyMd)
                    .foregroundStyle(AppTheme.Colors.onSurface)
                Spacer()
                Text(String(format: "%.1f m", value.wrappedValue))
                    .font(AppTheme.Typography.labelMd)
                    .foregroundStyle(AppTheme.Colors.primary)
            }
            .padding(.vertical, 12)

            if editMode {
                Slider(value: value, in: range, step: 0.1)
                    .tint(AppTheme.Colors.primary)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: editMode)
    }
}

#Preview {
    NavigationStack {
        MeasurementsView()
            .environment(NavigationRouter())
    }
}
