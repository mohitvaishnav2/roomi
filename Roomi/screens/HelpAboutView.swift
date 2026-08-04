import SwiftUI

// MARK: - Help & About View (Screen 30)
struct HelpAboutView: View {
    @State private var expandedFAQ: String? = nil

    private let faqItems: [(String, String)] = [
        ("How accurate is the room scan?", "RoomIQ uses LiDAR and ARKit to achieve up to 97% accuracy on iPhone 12 Pro and later. Older models use depth estimation for slightly lower accuracy."),
        ("Is my room data private?", "Yes. All scan data is processed on-device using Apple's Neural Engine. Nothing leaves your phone without your explicit export action."),
        ("How many rooms can I scan?", "Free tier: 3 scans per month. Premium: unlimited scans across your entire home."),
        ("Can I use AR without scanning first?", "Yes! AR furniture placement works with any camera view. A scan improves accuracy and snap-to-floor detection."),
        ("What's the minimum iOS version?", "RoomIQ requires iOS 17 or later for full feature support. AR Placement requires iOS 17+ with A12 Bionic or later."),
        ("How do I export my designs?", "Premium subscribers can export PDF floor plans, mood boards, and shopping lists from any project's detail view."),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // App Info
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [AppTheme.Colors.primaryContainer, AppTheme.Colors.surfaceVariant],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 96, height: 96)
                        Image(systemName: "sparkles")
                            .font(.system(size: 40, weight: .light))
                            .foregroundStyle(AppTheme.Colors.primary)
                    }

                    Text("RoomIQ AI")
                        .font(AppTheme.Typography.headlineMd)
                        .foregroundStyle(AppTheme.Colors.onSurface)
                    Text("Version 1.0.0 · Built with ❤️ for iOS 17+")
                        .font(AppTheme.Typography.labelSm)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                }
                .padding(.top, 16)

                // Support Links
                VStack(spacing: 4) {
                    SectionHeader(title: "Get Help")
                        .padding(.horizontal, 24)

                    supportRow(icon: "bubble.left.and.bubble.right", title: "Chat Support", subtitle: "Usually responds in 2 hours") {}
                    supportRow(icon: "envelope", title: "Email Support", subtitle: "hello@roomiq.app") {}
                    supportRow(icon: "safari", title: "Visit Website", subtitle: "roomiq.app") {}
                    supportRow(icon: "star", title: "Rate on App Store", subtitle: "Your review helps us grow") {}
                }

                // FAQ
                VStack(spacing: 8) {
                    SectionHeader(title: "Frequently Asked Questions")
                        .padding(.horizontal, 24)

                    ForEach(faqItems, id: \.0) { question, answer in
                        VStack(spacing: 0) {
                            Button {
                                withAnimation(.interactiveSpring(response: 0.35, dampingFraction: 0.8)) {
                                    expandedFAQ = expandedFAQ == question ? nil : question
                                }
                            } label: {
                                HStack {
                                    Text(question)
                                        .font(AppTheme.Typography.labelMd)
                                        .foregroundStyle(AppTheme.Colors.onSurface)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    Image(systemName: expandedFAQ == question ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                                }
                                .padding(18)
                            }
                            .buttonStyle(.plain)

                            if expandedFAQ == question {
                                Text(answer)
                                    .font(AppTheme.Typography.bodyMd)
                                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                                    .padding(.horizontal, 18)
                                    .padding(.bottom, 18)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .background(AppTheme.Colors.surfaceContainerLowest)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
                        .padding(.horizontal, 16)
                    }
                }

                // Legal
                VStack(spacing: 8) {
                    HStack(spacing: 20) {
                        Button("Privacy Policy") {}
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.primary)
                        Button("Terms of Service") {}
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.primary)
                        Button("Open Source") {}
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.primary)
                    }
                    Text("© 2025 RoomIQ AI. All rights reserved.")
                        .font(AppTheme.Typography.labelSm)
                        .foregroundStyle(AppTheme.Colors.outline)
                }
                .padding(.bottom, 40)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Help & About")
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private func supportRow(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(AppTheme.Colors.primaryContainer).frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(AppTheme.Colors.primary)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(AppTheme.Colors.onSurface)
                    Text(subtitle)
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

#Preview {
    NavigationStack {
        HelpAboutView()
    }
}
