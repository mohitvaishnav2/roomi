import SwiftUI

// MARK: - Premium View (Screen 26)
struct PremiumView: View {
    @Environment(NavigationRouter.self) private var router
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: Plan = .annual

    enum Plan { case monthly, annual }

    private let features: [(icon: String, title: String, body: String)] = [
        ("sparkles", "Unlimited AI Designs", "Generate as many room concepts as you want."),
        ("cube.transparent", "AR Placement", "Preview any furniture in your actual space."),
        ("camera.viewfinder", "Unlimited Scans", "Scan every room in your home."),
        ("paintpalette", "Full Material Library", "300+ curated materials and colour palettes."),
        ("cloud.fill", "Cloud Sync", "Access projects on all your devices."),
        ("arrow.down.doc", "Export Designs", "Download floor plans and mood boards."),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "#2C1B0E"), Color(hex: "#5C3A1E"), Color(hex: "#C8A96E")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 300)
                    .ignoresSafeArea(edges: .top)

                    VStack(spacing: 16) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 52, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(colors: [Color(hex: "#FFD700"), Color(hex: "#FFA500")],
                                               startPoint: .top, endPoint: .bottom)
                            )
                            .shadow(color: Color(hex: "#FFD700").opacity(0.5), radius: 16)

                        Text("RoomIQ Premium")
                            .font(AppTheme.Typography.displayLg)
                            .foregroundStyle(.white)

                        Text("Unlock the full design studio experience")
                            .font(AppTheme.Typography.bodyMd)
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 20)
                }
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
                .padding(.horizontal, 0)

                VStack(spacing: 24) {
                    // Plan Selector
                    VStack(spacing: 12) {
                        planCard(
                            plan: .annual,
                            title: "Annual",
                            price: "$59.99",
                            period: "/ year",
                            savings: "Save 50%",
                            subtext: "$4.99/month"
                        )
                        planCard(
                            plan: .monthly,
                            title: "Monthly",
                            price: "$9.99",
                            period: "/ month",
                            savings: nil,
                            subtext: "Cancel anytime"
                        )
                    }

                    // Features
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(title: "Everything Included")

                        ForEach(features, id: \.title) { f in
                            HStack(spacing: 14) {
                                Image(systemName: f.icon)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color(hex: "#C8A96E"))
                                    .frame(width: 22)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(f.title)
                                        .font(AppTheme.Typography.labelMd)
                                        .foregroundStyle(AppTheme.Colors.onSurface)
                                    Text(f.body)
                                        .font(AppTheme.Typography.labelSm)
                                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                                }
                            }
                        }
                    }

                    // CTA
                    VStack(spacing: 12) {
                        Button {
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(Color(hex: "#FFD700"))
                                Text(selectedPlan == .annual ? "Start Annual — $59.99/yr" : "Start Monthly — $9.99/mo")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "#C8A96E"), Color(hex: "#E8C48A")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundStyle(Color(hex: "#2C1B0E"))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(ScaleButtonStyle())

                        Text("7-day free trial · Cancel anytime · Billed through App Store")
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Restore") {}
                    .foregroundStyle(AppTheme.Colors.primary)
                    .font(AppTheme.Typography.labelSm)
            }
        }
    }

    @ViewBuilder
    private func planCard(plan: Plan, title: String, price: String, period: String, savings: String?, subtext: String) -> some View {
        Button { withAnimation { selectedPlan = plan } } label: {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(AppTheme.Typography.labelMd)
                            .foregroundStyle(AppTheme.Colors.onSurface)
                        if let savings {
                            Text(savings)
                                .font(AppTheme.Typography.labelSm)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(AppTheme.Colors.primary, in: Capsule())
                        }
                    }
                    Text(subtext)
                        .font(AppTheme.Typography.labelSm)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                }
                Spacer()
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(price)
                        .font(AppTheme.Typography.headlineMd)
                        .foregroundStyle(AppTheme.Colors.onSurface)
                    Text(period)
                        .font(AppTheme.Typography.labelSm)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                }

                Image(systemName: selectedPlan == plan ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(selectedPlan == plan ? AppTheme.Colors.primary : AppTheme.Colors.outlineVariant)
                    .font(.system(size: 22))
                    .padding(.leading, 8)
            }
            .padding(18)
            .background(
                selectedPlan == plan
                ? AppTheme.Colors.primaryContainer.opacity(0.4)
                : AppTheme.Colors.surfaceContainerLowest
            )
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.xxl)
                    .strokeBorder(selectedPlan == plan ? AppTheme.Colors.primary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    NavigationStack {
        PremiumView()
            .environment(NavigationRouter())
    }
}
