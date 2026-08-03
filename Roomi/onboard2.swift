import SwiftUI

// MARK: - Onboarding Screen 2 – "Modern Design"
/// Second onboarding screen. Converted from HTML design.
/// Second dot active; "Modern Design" headline; custom bottom-rounded hero.
struct Onboard2View: View {

    @Environment(\.dismiss) private var dismiss
    @State private var navigateToLogin = false

    var body: some View {
        ZStack {
            AppTheme.Colors.brandBg.ignoresSafeArea()

            VStack(spacing: 0) {
                heroSection
                bottomContent
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToLogin) {
            WelcomeView()
        }
    }

    // MARK: – Hero image
    private var heroSection: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                // Hero image with rounded bottom
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDpxYtknGdcoBvjIiw-ocIXl2vHFU2MC7Ddkt95HUEwqbUJoAJtAnQgNrSdGByQdEEQsUsSwl5OpD29Z4PLoSK-xfB_hEiw3QBoIzD8LCAhzKKBD8ir36UUtIh3q9K-rsR5yXNLVV_j1KW37QPYd_rpc57qNuBdOHWYPAUf_UtnMOysVbDxQ4fbGlF2nwEFz5YHrhs1-b-mEngcDA3iwWK3_yxgXCRfRZS6vDK5zfND-n5B_BEdNlX2bg")) { phase in
                    switch phase {
                    case .success(let img): img.resizable().scaledToFill()
                    default: Rectangle().fill(AppTheme.Colors.brandBg)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
                .clipShape(BottomRoundedShape(radius: 48))

                // Skip button
                HStack {
                    Spacer()
                    Button(action: { navigateToLogin = true }) {
                        HStack(spacing: 4) {
                            Text("Skip")
                                .font(.system(size: 14, weight: .medium))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(Color(.systemGray))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.85))
                        .clipShape(Capsule())
                    }
                    .padding(.trailing, 24)
                    .padding(.top, 48)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.58)
    }

    // MARK: – Bottom card
    private var bottomContent: some View {
        VStack(spacing: 0) {
            VStack(alignment: .center, spacing: 0) {
                VStack(spacing: 16) {
                    Text("Modern Design")
                        .font(.custom("Quicksand", size: 26).bold())
                        .foregroundColor(AppTheme.Colors.brandPeach)
                        .tracking(1)
                        .multilineTextAlignment(.center)

                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#7A7A7A"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .padding(.horizontal, 16)
                }
                .padding(.top, 48)
                .padding(.horizontal, 32)

                Spacer()

                // Footer nav
                HStack {
                    HStack(spacing: 8) {
                        pagesDot(active: false)
                        pagesDot(active: true)
                        pagesDot(active: false)
                        pagesDot(active: false)
                    }
                    Spacer()
                    Button(action: { navigateToLogin = true }) {
                        Text("Next")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(AppTheme.Colors.brandPeach)
                            .clipShape(Capsule())
                            .shadow(color: AppTheme.Colors.brandPeach.opacity(0.35), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 44)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
            .offset(y: -16)
        }
    }

    @ViewBuilder
    private func pagesDot(active: Bool) -> some View {
        Capsule()
            .fill(active ? AppTheme.Colors.brandPeach : AppTheme.Colors.brandPeach.opacity(0.3))
            .frame(width: active ? 24 : 8, height: 8)
    }
}

// MARK: - BottomRoundedShape – rounds only the bottom two corners
struct BottomRoundedShape: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                    radius: radius, startAngle: .degrees(0),
                    endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                    radius: radius, startAngle: .degrees(90),
                    endAngle: .degrees(180), clockwise: false)
        path.closeSubpath()
        return path
    }
}

#Preview {
    NavigationStack { Onboard2View() }
}
