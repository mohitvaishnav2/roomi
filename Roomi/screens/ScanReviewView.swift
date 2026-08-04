import SwiftUI

// MARK: - Scan Review View (Screen 12)
struct ScanReviewView: View {
    @Environment(NavigationRouter.self) private var router

    private let measurements = RoomMeasurements(width: 5.2, length: 7.8, height: 2.7)

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 3D Model Preview
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "#1A1A2E"), Color(hex: "#2C2C4A"), Color(hex: "#3D3D5C")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))

                    VStack(spacing: 16) {
                        // Isometric room wireframe
                        IsometricRoomPreview()
                            .frame(width: 180, height: 140)

                        Label("3D Spatial Model", systemImage: "cube.transparent")
                            .font(AppTheme.Typography.labelMd)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal, 16)
                .shadow(color: .black.opacity(0.2), radius: 20, y: 8)

                // Scan Quality Badge
                HStack(spacing: 0) {
                    ForEach(["Accuracy: 97%", "Points: 48,240", "Coverage: Full"], id: \.self) { badge in
                        Text(badge)
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.tertiary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .frame(maxWidth: .infinity)
                        if badge != "Coverage: Full" {
                            Divider().frame(height: 20)
                        }
                    }
                }
                .background(AppTheme.Colors.tertiaryContainer.opacity(0.4), in: Capsule())
                .padding(.horizontal, 24)

                // Measurements
                VStack(spacing: 0) {
                    SectionHeader(title: "Room Measurements")
                        .padding(.bottom, 8)

                    Divider()
                    MeasurementRow(label: "Width", value: measurements.formattedWidth, icon: "arrow.left.and.right")
                    Divider()
                    MeasurementRow(label: "Length", value: measurements.formattedLength, icon: "arrow.up.and.down")
                    Divider()
                    MeasurementRow(label: "Height", value: measurements.formattedHeight, icon: "arrow.up.to.line")
                    Divider()
                    MeasurementRow(label: "Floor Area", value: measurements.formattedArea, icon: "square")
                }
                .padding(.horizontal, 24)
                .padding(20)
                .background(AppTheme.Colors.surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
                .shadow(color: Color(hex: "#8C634F").opacity(0.07), radius: 12, y: 4)
                .padding(.horizontal, 16)

                // Scan Steps
                VStack(alignment: .leading, spacing: 10) {
                    SectionHeader(title: "Scan Summary")
                    ForEach(["Walls detected", "Floor mapped", "Ceiling captured", "Furniture detected (3 items)", "AI analysis complete"], id: \.self) { step in
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(AppTheme.Colors.tertiary)
                            Text(step)
                                .font(AppTheme.Typography.bodyMd)
                                .foregroundStyle(AppTheme.Colors.onSurface)
                        }
                    }
                }
                .padding(.horizontal, 24)

                // Actions
                VStack(spacing: 12) {
                    PrimaryButton("Generate AI Design", icon: "sparkles") {
                        router.push(.aiDesignBrief)
                    }
                    SecondaryButton("Rescan Room", icon: "arrow.counterclockwise") {
                        router.pop()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Scan Review")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Isometric Room Preview
private struct IsometricRoomPreview: View {
    var body: some View {
        Canvas { context, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Floor
            var floor = Path()
            floor.move(to: CGPoint(x: cx, y: cy + 40))
            floor.addLine(to: CGPoint(x: cx + 70, y: cy + 10))
            floor.addLine(to: CGPoint(x: cx, y: cy - 20))
            floor.addLine(to: CGPoint(x: cx - 70, y: cy + 10))
            floor.closeSubpath()
            context.fill(floor, with: .color(.white.opacity(0.05)))
            context.stroke(floor, with: .color(.white.opacity(0.3)), lineWidth: 1)

            // Left Wall
            var left = Path()
            left.move(to: CGPoint(x: cx - 70, y: cy + 10))
            left.addLine(to: CGPoint(x: cx, y: cy - 20))
            left.addLine(to: CGPoint(x: cx, y: cy - 80))
            left.addLine(to: CGPoint(x: cx - 70, y: cy - 50))
            left.closeSubpath()
            context.fill(left, with: .color(.white.opacity(0.08)))
            context.stroke(left, with: .color(.white.opacity(0.4)), lineWidth: 1)

            // Right Wall
            var right = Path()
            right.move(to: CGPoint(x: cx, y: cy - 20))
            right.addLine(to: CGPoint(x: cx + 70, y: cy + 10))
            right.addLine(to: CGPoint(x: cx + 70, y: cy - 50))
            right.addLine(to: CGPoint(x: cx, y: cy - 80))
            right.closeSubpath()
            context.fill(right, with: .color(.white.opacity(0.04)))
            context.stroke(right, with: .color(.white.opacity(0.3)), lineWidth: 1)

            // Grid lines on floor
            for i in 1...3 {
                let t = CGFloat(i) / 4
                var line = Path()
                let start = CGPoint(x: cx - 70 + 140 * t, y: cy + 10 - 30 * t)
                let end = CGPoint(x: cx - 70 * (1 - t), y: cy + 40 - 60 * t)
                line.move(to: start)
                line.addLine(to: end)
                context.stroke(line, with: .color(.white.opacity(0.1)), lineWidth: 0.5)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ScanReviewView()
            .environment(NavigationRouter())
    }
}
