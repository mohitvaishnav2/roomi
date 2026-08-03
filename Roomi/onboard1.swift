import SwiftUI

// MARK: - Onboarding Screen 1 – "Comfortable Space"
/// First onboarding screen. Converted from HTML design.
/// Features a full-bleed hero image, bottom card with title/body, pagination dots and Next button.
struct Onboard1View: View {

    @State private var navigateToOnboard2 = false
    @State private var navigateToLogin    = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                heroSection
                bottomContent
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToOnboard2) {
            Onboard2View()
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            WelcomeView()
        }
    }

    // MARK: – Hero image
    private var heroSection: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                // Hero image
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDFDLpCMD97FPm9LYWQEu52G0BplzrhOwtFMt3EBTmudDiE5XaDvdZNl3u270F0fLS5R40la6EeKT_YSXOZ0Kj9S8XbJH0sxuMMGRT-6rM-B9eOBe3EbGlVoGBzWrNcljZeN8lGRYBBT3nshq9jUJzWymZymTdpU0c2EytqKgoCzH1t2DNWV6LtYo8SIMTKnfpvyhrP-gyqzjEiDXfME71jd5yGOZetE2mfij5M__peeRj3_2AECSeCvA")) { phase in
                    switch phase {
                    case .success(let img): img.resizable().scaledToFill()
                    default: Rectangle().fill(AppTheme.Colors.peachLight)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))

                // Skip button
                HStack {
                    Spacer()
                    Button(action: { navigateToLogin = true }) {
                        HStack(spacing: 4) {
                            Text("Skip")
                                .font(.system(size: 14, weight: .medium))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(Color(.systemGray))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.85))
                        .clipShape(Capsule())
                    }
                    .padding(.trailing, 24)
                    .padding(.top, 56)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.60)
    }

    // MARK: – Bottom card
    private var bottomContent: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                // Text block
                VStack(spacing: 12) {
                    Text("Comfortable Space")
                        .font(.custom("Quicksand", size: 26).bold())
                        .foregroundColor(AppTheme.Colors.peach)
                        .multilineTextAlignment(.center)

                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                        .font(.system(size: 13))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 8)
                }
                .padding(.top, 32)
                .padding(.horizontal, 32)

                Spacer()

                // Pagination + Next
                HStack {
                    HStack(spacing: 8) {
                        pagesDot(active: true)
                        pagesDot(active: false)
                        pagesDot(active: false)
                        pagesDot(active: false)
                    }
                    Spacer()
                    Button(action: { navigateToOnboard2 = true }) {
                        Text("Next")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(AppTheme.Colors.peach)
                            .clipShape(Capsule())
                            .shadow(color: AppTheme.Colors.peach.opacity(0.35), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
            .offset(y: -20)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func pagesDot(active: Bool) -> some View {
        Capsule()
            .fill(active ? AppTheme.Colors.peach : AppTheme.Colors.peachLight)
            .frame(width: active ? 24 : 8, height: 8)
    }
}

#Preview {
    NavigationStack { Onboard1View() }
}
