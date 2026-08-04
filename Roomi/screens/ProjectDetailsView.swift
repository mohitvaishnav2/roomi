import SwiftUI

// MARK: - Project Details View (Screen 23)
struct ProjectDetailsView: View {
    let projectID: String
    @Environment(NavigationRouter.self) private var router

    private var project: RoomProject {
        RoomProject.sampleProjects.first(where: { $0.id == projectID })
        ?? RoomProject.sampleProjects[0]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        colors: project.gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 240)
                    .overlay(
                        Image(systemName: project.roomType.icon)
                            .font(.system(size: 80, weight: .ultraLight))
                            .foregroundStyle(.white.opacity(0.2))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .padding(24)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))

                    VStack(alignment: .leading, spacing: 6) {
                        if project.isCompleted {
                            Label("Completed", systemImage: "checkmark.circle.fill")
                                .font(AppTheme.Typography.labelSm)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 5)
                                .background(AppTheme.Colors.tertiary.opacity(0.8), in: Capsule())
                        }
                        Text(project.name)
                            .font(AppTheme.Typography.headlineLgMobile)
                            .foregroundStyle(.white)
                        Text("\(project.roomType.rawValue) · \(project.style.rawValue)")
                            .font(AppTheme.Typography.bodyMd)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(20)
                }
                .padding(.horizontal, 16)
                .shadow(color: Color(hex: "#8C634F").opacity(0.12), radius: 20, y: 8)

                // Measurements
                if let measurements = project.measurements {
                    VStack(spacing: 0) {
                        SectionHeader(title: "Room Dimensions")
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
                    .padding(20)
                    .background(AppTheme.Colors.surfaceContainerLowest)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
                    .shadow(color: Color(hex: "#8C634F").opacity(0.07), radius: 10, y: 3)
                    .padding(.horizontal, 16)
                }

                // Design Actions
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeader(title: "Design Tools")
                        .padding(.horizontal, 16)

                    ForEach(projectActions, id: \.title) { action in
                        Button { action.handler(router) } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle().fill(action.color.opacity(0.12)).frame(width: 44, height: 44)
                                    Image(systemName: action.icon)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(action.color)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(action.title)
                                        .font(AppTheme.Typography.labelMd)
                                        .foregroundStyle(AppTheme.Colors.onSurface)
                                    Text(action.subtitle)
                                        .font(AppTheme.Typography.labelSm)
                                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(AppTheme.Colors.outlineVariant)
                            }
                            .padding(16)
                            .background(AppTheme.Colors.surfaceContainerLowest)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .padding(.horizontal, 16)
                    }
                }

                // Created
                Text("Created \(project.createdAt.formatted(date: .long, time: .omitted))")
                    .font(AppTheme.Typography.labelSm)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    .padding(.bottom, 40)
            }
            .padding(.top, 16)
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button { } label: { Label("Rename", systemImage: "pencil") }
                    Button { } label: { Label("Duplicate", systemImage: "doc.on.doc") }
                    Button(role: .destructive) { } label: { Label("Delete", systemImage: "trash") }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(AppTheme.Colors.primary)
                }
            }
        }
    }

    private var projectActions: [(title: String, subtitle: String, icon: String, color: Color, handler: (NavigationRouter) -> Void)] {
        [
            ("AI Design", "Generate new concepts", "sparkles", AppTheme.Colors.primary, { $0.push(.aiDesignBrief) }),
            ("Before & After", "Compare transformation", "arrow.left.and.right", AppTheme.Colors.tertiary, { $0.push(.beforeAfter) }),
            ("Furniture Picks", "Explore AI recommendations", "sofa", Color(hex: "#8B7355"), { $0.push(.furnitureRecommendations) }),
            ("AR Placement", "Preview in your room", "cube.transparent", Color(hex: "#5B8DB8"), { $0.push(.arPlacement) }),
            ("Measurements", "Edit room dimensions", "ruler", AppTheme.Colors.secondary, { $0.push(.measurements) }),
        ]
    }
}

#Preview {
    NavigationStack {
        ProjectDetailsView(projectID: "1")
            .environment(NavigationRouter())
    }
}
