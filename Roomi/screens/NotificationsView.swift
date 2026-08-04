import SwiftUI

// MARK: - Notifications View (Screen 25)
struct NotificationsView: View {
    @State private var notifications = AppNotification.sampleNotifications

    private var unreadCount: Int { notifications.filter { !$0.isRead }.count }

    var body: some View {
        Group {
            if notifications.isEmpty {
                EmptyStateView(
                    icon: "bell.slash",
                    title: "All caught up!",
                    subtitle: "You have no notifications right now."
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        if unreadCount > 0 {
                            HStack {
                                Text("\(unreadCount) unread")
                                    .font(AppTheme.Typography.labelSm)
                                    .foregroundStyle(AppTheme.Colors.primary)
                                Spacer()
                                Button("Mark all read") {
                                    withAnimation {
                                        notifications = notifications.map { n in
                                            var copy = n
                                            return AppNotification(
                                                id: n.id, title: n.title, body: n.body,
                                                type: n.type, date: n.date, isRead: true
                                            )
                                        }
                                    }
                                }
                                .font(AppTheme.Typography.labelSm)
                                .foregroundStyle(AppTheme.Colors.primary)
                            }
                            .padding(.horizontal, 16)
                        }

                        ForEach(notifications) { notification in
                            NotificationRow(notification: notification)
                                .padding(.horizontal, 16)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            notifications.removeAll { $0.id == notification.id }
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .onTapGesture {
                                    withAnimation {
                                        if let idx = notifications.firstIndex(where: { $0.id == notification.id }) {
                                            notifications[idx] = AppNotification(
                                                id: notification.id, title: notification.title,
                                                body: notification.body, type: notification.type,
                                                date: notification.date, isRead: true
                                            )
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if !notifications.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        withAnimation { notifications.removeAll() }
                    }
                    .foregroundStyle(AppTheme.Colors.error)
                    .font(AppTheme.Typography.labelSm)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
}
