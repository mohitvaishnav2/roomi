import SwiftUI

// MARK: - Settings View (Screen 29)
struct SettingsView: View {
    @EnvironmentObject private var auth: AuthManager
    @State private var scanQuality: ScanQuality = .high
    @State private var useMetric = true
    @State private var pushEnabled = true
    @State private var hapticEnabled = true
    @State private var autoSave = true
    @State private var showDeleteAlert = false

    enum ScanQuality: String, CaseIterable {
        case standard = "Standard"
        case high = "High"
        case ultra = "Ultra HD"
    }

    var body: some View {
        Form {
            // Scanning
            Section {
                Picker("Scan Quality", selection: $scanQuality) {
                    ForEach(ScanQuality.allCases, id: \.self) { q in
                        Text(q.rawValue).tag(q)
                    }
                }
                .tint(AppTheme.Colors.primary)

                Toggle("Metric System (m, m²)", isOn: $useMetric)
                    .tint(AppTheme.Colors.primary)

                Toggle("Auto-save Scans", isOn: $autoSave)
                    .tint(AppTheme.Colors.primary)
            } header: {
                Text("Scanning & Measurement")
            }

            // Notifications
            Section {
                Toggle("Push Notifications", isOn: $pushEnabled)
                    .tint(AppTheme.Colors.primary)

                Toggle("Haptic Feedback", isOn: $hapticEnabled)
                    .tint(AppTheme.Colors.primary)
            } header: {
                Text("Notifications & Feedback")
            }

            // Privacy
            Section {
                NavigationLink("Privacy Settings") { privacyView }
                NavigationLink("Camera & Permissions") { permissionsView }
                Button("Export My Data") {}
                    .foregroundStyle(AppTheme.Colors.primary)
            } header: {
                Text("Privacy & Data")
            }

            // Appearance
            Section {
                Button("Clear Cache") {}
                    .foregroundStyle(AppTheme.Colors.primary)
            } header: {
                Text("Storage")
            } footer: {
                Text("Cache: 47.2 MB")
            }

            // Danger
            Section {
                Button("Delete All Projects") {
                    showDeleteAlert = true
                }
                .foregroundStyle(AppTheme.Colors.error)

                Button("Sign Out") {
                    auth.signOut()
                }
                .foregroundStyle(AppTheme.Colors.error)
            } header: {
                Text("Danger Zone")
            }

            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0 (Build 42)")
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .alert("Delete All Projects?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all your room scans and design projects. This cannot be undone.")
        }
    }

    private var privacyView: some View {
        List {
            Text("Camera access is only used during active scanning sessions.")
            Text("Scan data is processed locally on your device.")
            Text("No room data is uploaded without your explicit consent.")
        }
        .navigationTitle("Privacy")
    }

    private var permissionsView: some View {
        List {
            Label("Camera — Enabled", systemImage: "camera.fill")
            Label("Photo Library — Ask Each Time", systemImage: "photo")
        }
        .navigationTitle("Permissions")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AuthManager())
    }
}
