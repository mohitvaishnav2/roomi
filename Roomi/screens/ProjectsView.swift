import SwiftUI

// MARK: - Projects View (Screen 22)
struct ProjectsView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var selectedFilter: ProjectFilter = .all
    @State private var showNewProjectSheet = false

    enum ProjectFilter: String, CaseIterable {
        case all = "All"
        case inProgress = "In Progress"
        case completed = "Completed"
    }

    private var filteredProjects: [RoomProject] {
        switch selectedFilter {
        case .all: return RoomProject.sampleProjects
        case .inProgress: return RoomProject.sampleProjects.filter { !$0.isCompleted }
        case .completed: return RoomProject.sampleProjects.filter { $0.isCompleted }
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Stats
                HStack(spacing: 12) {
                    StatCard(icon: "folder", value: "\(RoomProject.sampleProjects.count)", label: "Total Projects", accentColor: AppTheme.Colors.primary)
                    StatCard(icon: "clock", value: "\(RoomProject.sampleProjects.filter { !$0.isCompleted }.count)", label: "In Progress", accentColor: AppTheme.Colors.secondary)
                    StatCard(icon: "checkmark.circle", value: "\(RoomProject.sampleProjects.filter { $0.isCompleted }.count)", label: "Completed", accentColor: AppTheme.Colors.tertiary)
                }
                .padding(.horizontal, 16)

                // Filter
                HStack(spacing: 8) {
                    ForEach(ProjectFilter.allCases, id: \.self) { filter in
                        Button { withAnimation { selectedFilter = filter } } label: {
                            Text(filter.rawValue)
                                .font(AppTheme.Typography.labelMd)
                                .foregroundStyle(selectedFilter == filter ? AppTheme.Colors.primary : AppTheme.Colors.onSurfaceVariant)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 10)
                                .background(
                                    selectedFilter == filter
                                    ? AppTheme.Colors.primaryContainer
                                    : AppTheme.Colors.surfaceContainer
                                )
                                .clipShape(Capsule())
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)

                // Project Grid
                if filteredProjects.isEmpty {
                    EmptyStateView(
                        icon: "folder.badge.plus",
                        title: "No projects yet",
                        subtitle: "Scan a room to start your first design project.",
                        action: ("Scan a Room", { router.push(.scanPrep) })
                    )
                    .frame(height: 300)
                } else {
                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)],
                        spacing: 14
                    ) {
                        ForEach(filteredProjects) { project in
                            RoomCard(project: project) {
                                router.push(.projectDetails(projectID: project.id))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Projects")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { router.push(.scanPrep) } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(AppTheme.Colors.primary)
                        .font(.system(size: 22))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProjectsView()
            .environment(NavigationRouter())
    }
}
