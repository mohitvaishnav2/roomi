import SwiftUI

// MARK: - Scan Prep View (Screen 10)
struct ScanPrepView: View {
    @Environment(NavigationRouter.self) private var router
    @Environment(\.dismiss) private var dismiss
    @State private var cameraPermission: PermissionStatus = .unknown
    @State private var checkedItems: Set<Int> = []

    enum PermissionStatus { case unknown, granted, denied }

    private let tips: [(icon: String, title: String, body: String)] = [
        ("sun.max", "Good Lighting", "Scan in natural daylight or well-lit rooms for best accuracy."),
        ("figure.walk", "Move Slowly", "Walk around the room at a steady pace, covering all corners."),
        ("arrow.triangle.2.circlepath", "Full Coverage", "Tilt your phone up and down to capture the floor, walls, and ceiling."),
        ("wifi", "Stay Connected", "Keep Wi-Fi on for real-time AI processing after scan."),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Illustration
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "#F8D7CC"), Color(hex: "#DFC0B5")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))

                    VStack(spacing: 12) {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 60, weight: .ultraLight))
                            .foregroundStyle(AppTheme.Colors.primary)

                        Text("Ready to scan")
                            .font(AppTheme.Typography.headlineMd)
                            .foregroundStyle(AppTheme.Colors.onSurface)
                        Text("Follow the tips below for best results")
                            .font(AppTheme.Typography.bodyMd)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }
                }
                .padding(.horizontal, 16)

                // Camera Permission
                if cameraPermission != .granted {
                    PermissionCard(
                        icon: "camera",
                        title: "Camera Access Required",
                        description: "RoomIQ needs your camera to create a 3D spatial model of your room.",
                        onAllow: { cameraPermission = .granted }
                    )
                    .padding(.horizontal, 16)
                }

                // Scanning Tips
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Before You Start")
                        .padding(.horizontal, 24)

                    ForEach(tips.indices, id: \.self) { idx in
                        let tip = tips[idx]
                        HStack(spacing: 14) {
                            Button {
                                withAnimation {
                                    if checkedItems.contains(idx) {
                                        checkedItems.remove(idx)
                                    } else {
                                        checkedItems.insert(idx)
                                    }
                                }
                            } label: {
                                Image(systemName: checkedItems.contains(idx) ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 22))
                                    .foregroundStyle(checkedItems.contains(idx) ? AppTheme.Colors.primary : AppTheme.Colors.outlineVariant)
                                    .animation(.spring(response: 0.3), value: checkedItems.contains(idx))
                            }

                            ZStack {
                                Circle().fill(AppTheme.Colors.primaryContainer).frame(width: 40, height: 40)
                                Image(systemName: tip.icon)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(AppTheme.Colors.primary)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(tip.title)
                                    .font(AppTheme.Typography.labelMd)
                                    .foregroundStyle(AppTheme.Colors.onSurface)
                                Text(tip.body)
                                    .font(AppTheme.Typography.labelSm)
                                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                                    .lineLimit(2)
                            }
                        }
                        .padding(16)
                        .background(
                            checkedItems.contains(idx)
                            ? AppTheme.Colors.primaryContainer.opacity(0.3)
                            : AppTheme.Colors.surfaceContainerLowest
                        )
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
                        .animation(.easeInOut(duration: 0.2), value: checkedItems.contains(idx))
                        .padding(.horizontal, 16)
                    }
                }

                // Privacy Note
                PrivacyBadge(label: "Camera feed is processed locally — never stored.", icon: "camera.badge.checkmark")
                    .frame(maxWidth: .infinity, alignment: .center)

                // CTA
                VStack(spacing: 12) {
                    PrimaryButton("Start Scanning", icon: "camera.viewfinder") {
                        router.push(.roomScanner)
                    }
                    .disabled(cameraPermission != .granted)
                    .opacity(cameraPermission == .granted ? 1.0 : 0.5)

                    Button("Choose Room from Photo Library") {}
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(AppTheme.Colors.primary)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Prepare to Scan")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            // Simulate checking permission state
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                cameraPermission = .unknown
            }
        }
    }
}

#Preview {
    NavigationStack {
        ScanPrepView()
            .environment(NavigationRouter())
    }
}
