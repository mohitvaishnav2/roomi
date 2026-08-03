import SwiftUI

// MARK: - Home View
struct HomeView: View {

    // MARK: Data
    private let styleItems: [StyleItem] = [
        StyleItem(name: "Modern",  color: Color(hex: "#C8B8B0"),
                  url: "https://lh3.googleusercontent.com/aida-public/AB6AXuASx-ixbiB_879pySlk3ft3W4gg1sGrD_zjA5eBcUIgjV3D_GlKTWMIjCiRdnn8y--DNeRxi97XUPkMoiOI0ZdwllzDW2cYKr1IMHAmEufmvPvizQhOcqNp8mOBxBbz4f1X1U6if2z_XC_LS3eiexzFoYg9kXkZd-6G2ag3ccZzv5cySWPprCWHIPn053Z9xtHbV7TOvEDSiSL8mW2TaVU1iHap7JtKb9wxKzPy3lcON0tbJXtANLpOHQ"),
        StyleItem(name: "Japandi", color: Color(hex: "#D4C9B8"),
                  url: "https://lh3.googleusercontent.com/aida-public/AB6AXuDTGA4eJQIvwyKhMSfDRrJL8D5jI_yMqy3E2U7nmj4p_VE7rqWTO2sD3oe5Lb9Tv8T0vZOJBusMslyP-bfGSmy89194qra7rp5a138gh1BIgbJXqUu0UKeroJrnG9w0USgxm0UawoE9Bs5UMD22Jz9wIh5pfIX6XK6Wd9ZFz4jYqtBD1IIfqAnphtVEibm6IgMtUgJIww86QMxHpfn3--qH4Wr-XMNHQYheKppBs-qhTGIKqsCwqi84ug"),
        StyleItem(name: "Luxury",  color: Color(hex: "#BEA898"),
                  url: "https://lh3.googleusercontent.com/aida-public/AB6AXuDwrljPCioIEFPN-P6gEVSJWX7N-HpuImHj2g30QLnw52dvjPzM1VjNKm3BvCXnk2Fq-lrvlJ4KoJOG0pud1Lgz23AWgpGXW2Fmw4IvHXaGLVp_fVj6uAod2CZr8SmL92vwiQQys0bbqG8R9Z9CdakwKQAUP4_5RtE3D_-AVuNQYvKOZAMAFEXHPQkwtQtZSybbdr2milEKt1bHNbwoGPA13M3O3ZOIS_oH5_UGX6QucUPFlL5ViRaYcw"),
        StyleItem(name: "Minimal", color: Color(hex: "#D8CECA"),
                  url: "https://lh3.googleusercontent.com/aida-public/AB6AXuCle12hEXSsvWFJEdnRvhN6OsPDa0DPw9f3NnCspH_ZV4QpOQA84cpmRJdQ8xAcEphKoPPHx7dH8HOk0FX5N5pqkms7PAxXKLjKx8tGTK54cCgsjL7cUc4QoQSf1kQCVkSfddwxVDYEDdavwknsiXf7s4Xph7_OVhvj_4CnX4ZrrTHLvEpVJ8sOxMdcnE5w0M6PVV_3GY_utDewo46hoLf0W7x2VEIhrBYvk5YSV3FacXinV_UoqYQn8w")
    ]

    private var quickToolItems: [(icon: String, label: String, bg: Color, fg: Color)] {[
        ("camera.viewfinder", "Scan Room",      AppTheme.Colors.primaryContainer.opacity(0.5), AppTheme.Colors.primary),
        ("wand.and.stars",    "AI Design",      AppTheme.Colors.secondaryContainer.opacity(0.5), AppTheme.Colors.secondary),
        ("paintbrush.fill",   "Paint Preview",  AppTheme.Colors.tertiaryContainer.opacity(0.5), AppTheme.Colors.tertiary),
        ("ruler.fill",        "Measure",        AppTheme.Colors.surfaceContainerHigh, AppTheme.Colors.primary),
        ("cube.fill",         "Furniture Fit",  AppTheme.Colors.surfaceContainerHigh, AppTheme.Colors.primary),
        ("sparkles",          "Style Match",    AppTheme.Colors.surfaceContainerHigh, AppTheme.Colors.primary)
    ]}

    // MARK: Body
    var body: some View {
        VStack(spacing: 0) {
            headerBar
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    heroBanner
                    quickToolsSection
                    VStack(spacing: 16) {
                        aiRecommendationCard
                        recentProjectCard
                    }
                    .padding(.horizontal, 20)
                    exploreStylesSection
                }
                .padding(.top, 12)
                .padding(.bottom, 120)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
    }

    // MARK: - Header Bar
    private var headerBar: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Hi, Mohit 👋")
                    .font(.custom("Quicksand-SemiBold", size: 26))
                    .foregroundColor(AppTheme.Colors.primary)
                Text("Let's transform your space")
                    .font(.custom("PlusJakartaSans-SemiBold", size: 13))
                    .foregroundColor(AppTheme.Colors.onSurfaceVariant)
            }
            Spacer()
            HStack(spacing: 10) {
                iconCircleButton(icon: "magnifyingglass")

                ZStack(alignment: .topTrailing) {
                    iconCircleButton(icon: "bell.fill")
                    Circle()
                        .fill(AppTheme.Colors.secondary)
                        .frame(width: 9, height: 9)
                        .offset(x: 3, y: -1)
                }

                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuAIzEkuQthLFzC-VaRCfTu2ZW3x_2spjObkoxEBvn-0PM-h7Mxf5YFTCA40ZPl9tqtseHlKY2Y3O_2XyUVAMX-YzJn7KcwcWRXRTvWnVocg6j6BqYu-9g_QbM6ItbsRIpkf5xwFtPcCuzTL819HP20THUYLwTLShbRy_g2rIVy0A4X6RWK1pQxLsAYLDR932x2UtVr2DXZ6d9XZyyh9MCbSvRgfj6JzkSXhqFOztE-eYbJmrHBYXWkZIA")) { img in
                    img.resizable().scaledToFill()
                } placeholder: {
                    AppTheme.Colors.surfaceContainer
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .shadow(color: Color(hex: "#8C634F").opacity(0.12), radius: 8, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
    }

    private func iconCircleButton(icon: String) -> some View {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(AppTheme.Colors.primary)
                .frame(width: 40, height: 40)
                .background(AppTheme.Colors.surfaceContainerHigh)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Hero Banner
    private var heroBanner: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(LinearGradient(
                    colors: [AppTheme.Colors.surfaceContainerHigh, AppTheme.Colors.primaryContainer.opacity(0.55)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))
                .frame(height: 230)

            // Dot pattern overlay
            Canvas { ctx, size in
                for row in stride(from: 0.0, to: size.height, by: 20) {
                    for col in stride(from: 150.0, to: size.width, by: 20) {
                        let rect = CGRect(x: col, y: row, width: 2, height: 2)
                        ctx.fill(Path(ellipseIn: rect), with: .color(AppTheme.Colors.primary.opacity(0.06)))
                    }
                }
            }
            .frame(height: 230)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 11, weight: .medium))
                    Text("AI Powered")
                        .font(.custom("PlusJakartaSans-Medium", size: 12))
                }
                .foregroundColor(AppTheme.Colors.primary)
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(AppTheme.Colors.primaryContainer)
                .clipShape(Capsule())

                Text("Design Your Dream\nRoom with AI")
                    .font(.custom("Quicksand-SemiBold", size: 24))
                    .foregroundColor(AppTheme.Colors.primary)
                    .lineSpacing(2)

                Button(action: {}) {
                    HStack(spacing: 8) {
                        Image(systemName: "arkit").font(.system(size: 14))
                        Text("Start Room Scan").font(.custom("PlusJakartaSans-SemiBold", size: 14))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20).padding(.vertical, 11)
                    .background(AppTheme.Colors.primary)
                    .clipShape(Capsule())
                    .shadow(color: AppTheme.Colors.primary.opacity(0.35), radius: 10, y: 4)
                }
                .buttonStyle(.plain)
            }
            .padding(24)

            // Carousel dots
            VStack {
                Spacer()
                HStack(spacing: 4) {
                    Capsule().fill(AppTheme.Colors.primary).frame(width: 20, height: 6)
                    Circle().fill(AppTheme.Colors.primary.opacity(0.25)).frame(width: 6)
                    Circle().fill(AppTheme.Colors.primary.opacity(0.25)).frame(width: 6)
                }
                .padding(.bottom, 18)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.horizontal, 20)
        .shadow(color: Color(hex: "#8C634F").opacity(0.09), radius: 24, y: 8)
    }

    // MARK: - Quick Tools
    private var quickToolsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Quick Tools")
                .font(AppTheme.Typography.headlineMd)
                .foregroundColor(AppTheme.Colors.primary)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(quickToolItems, id: \.label) { t in
                        VStack(spacing: 8) {
                            Button(action: {}) {
                                Image(systemName: t.icon)
                                    .font(.system(size: 24))
                                    .foregroundColor(t.fg)
                                    .frame(width: 64, height: 64)
                                    .background(t.bg)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                            .buttonStyle(.plain)
                            Text(t.label)
                                .font(.custom("PlusJakartaSans-Medium", size: 12))
                                .foregroundColor(AppTheme.Colors.onSurfaceVariant)
                                .multilineTextAlignment(.center)
                                .frame(width: 72)
                        }
                    }
                }
                .padding(.horizontal, 20).padding(.bottom, 4)
            }
        }
    }

    // MARK: - AI Recommendation Card
    private var aiRecommendationCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Recommended For You")
                .font(AppTheme.Typography.headlineMd)
                .foregroundColor(AppTheme.Colors.primary)

            HStack(alignment: .top, spacing: 16) {
                // Image
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuD9ToT1zbZ56Bi8RLjnC2h--BztisgwZ9ms2Qn70-LatPmqDNrJz_p4ySY9h3p8mCBoSCjEBJmHTnUXOb7nTTvHF4vuj68KyWeF818VxXaasOYX_Gmzr003fSaoklI8UtHgLLZqtyjvc2IGsHjGxhAkBOFJl7_3wYN3C6ZViwZvVG7lfZuMJgwxw9y_MVNC-74FzN3VMoTM9E0dWFjPQ8b8LZuktKQyH-RTkqmnrroKJqEtmxNkkvUOLA")) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        AppTheme.Colors.primaryContainer
                    }
                    .frame(width: 130, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill").font(.system(size: 10)).foregroundColor(AppTheme.Colors.secondary)
                        Text("92% Match").font(.custom("PlusJakartaSans-Medium", size: 11)).foregroundColor(AppTheme.Colors.primary)
                    }
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(8)
                }

                // Info
                VStack(alignment: .leading, spacing: 8) {
                    Text("Modern Japandi\nLiving Room")
                        .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                        .foregroundColor(AppTheme.Colors.primary)
                    Text("Based on your recent 'Minimalist' saves.")
                        .font(.custom("PlusJakartaSans-Regular", size: 13))
                        .foregroundColor(AppTheme.Colors.onSurfaceVariant)

                    VStack(alignment: .leading, spacing: 6) {
                        Label("Est. $2.5k", systemImage: "creditcard.fill")
                        Label("2 Weeks",  systemImage: "clock.fill")
                    }
                    .font(.custom("PlusJakartaSans-Medium", size: 12))
                    .foregroundColor(AppTheme.Colors.onSurfaceVariant)

                    Spacer()

                    Button(action: {}) {
                        Text("View Design")
                            .font(.custom("PlusJakartaSans-SemiBold", size: 13))
                            .foregroundColor(AppTheme.Colors.primary)
                            .padding(.horizontal, 18).padding(.vertical, 8)
                            .overlay(Capsule().stroke(AppTheme.Colors.primary, lineWidth: 1.5))
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color(hex: "#8C634F").opacity(0.09), radius: 20, y: 6)
    }

    // MARK: - Recent Project Card
    private var recentProjectCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Recent Projects")
                .font(AppTheme.Typography.headlineMd)
                .foregroundColor(AppTheme.Colors.primary)

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(AppTheme.Colors.secondaryContainer.opacity(0.5))
                            .frame(width: 48, height: 48)
                        Image(systemName: "sofa.fill")
                            .font(.system(size: 18))
                            .foregroundColor(AppTheme.Colors.secondary)
                    }
                    Spacer()
                    Text("2 hrs ago")
                        .font(.custom("PlusJakartaSans-Medium", size: 12))
                        .foregroundColor(AppTheme.Colors.onSurfaceVariant)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(AppTheme.Colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }

                Text("Living Room Scan")
                    .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                    .foregroundColor(AppTheme.Colors.primary)
                Text("Finalizing 3D render...")
                    .font(.custom("PlusJakartaSans-Regular", size: 13))
                    .foregroundColor(AppTheme.Colors.onSurfaceVariant)

                // Progress bar
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Progress").font(.custom("PlusJakartaSans-Medium", size: 12)).foregroundColor(AppTheme.Colors.primary)
                        Spacer()
                        Text("80%").font(.custom("PlusJakartaSans-Medium", size: 12)).foregroundColor(AppTheme.Colors.primary)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4).fill(AppTheme.Colors.surfaceContainer).frame(height: 8)
                            RoundedRectangle(cornerRadius: 4).fill(AppTheme.Colors.primary).frame(width: geo.size.width * 0.8, height: 8)
                        }
                    }
                    .frame(height: 8)
                }

                HStack {
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppTheme.Colors.primary)
                }
            }
            .padding(20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: Color(hex: "#8C634F").opacity(0.09), radius: 20, y: 6)
        }
    }

    // MARK: - Explore Styles
    private var exploreStylesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Explore Styles").font(AppTheme.Typography.headlineMd).foregroundColor(AppTheme.Colors.primary)
                Spacer()
                Button(action: {}) {
                    Text("View All").font(.custom("PlusJakartaSans-SemiBold", size: 14)).foregroundColor(AppTheme.Colors.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(styleItems) { item in
                        StyleCardView(item: item)
                    }
                }
                .padding(.horizontal, 20).padding(.bottom, 8)
            }
        }
    }
}

// MARK: - Style Card
struct StyleItem: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let url: String
}

struct StyleCardView: View {
    let item: StyleItem

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: item.url)) { img in
                img.resizable().scaledToFill()
            } placeholder: {
                item.color
            }
            .frame(width: 160, height: 200)
            .clipped()

            LinearGradient(colors: [.clear, Color.black.opacity(0.75)],
                           startPoint: .center, endPoint: .bottom)

            HStack {
                Text(item.name)
                    .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                    .foregroundColor(.white)
                Spacer()
                ZStack {
                    Circle().fill(AppTheme.Colors.primaryContainer.opacity(0.85)).frame(width: 26, height: 26)
                    Image(systemName: "sparkles").font(.system(size: 12)).foregroundColor(AppTheme.Colors.primary)
                }
            }
            .padding(.horizontal, 12).padding(.bottom, 12)
        }
        .frame(width: 160, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color(hex: "#8C634F").opacity(0.1), radius: 14, y: 4)
    }
}

#Preview {
    HomeView()
}
