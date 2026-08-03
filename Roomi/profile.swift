import SwiftUI

// MARK: - Profile View
struct ProfileView: View {

    @State private var fullName = "Mohit"
    @State private var email    = "mohit.design@example.com"
    @State private var phone    = "+1 (555) 019-2834"
    @State private var city     = "San Francisco"
    @State private var country  = "USA"

    @State private var selectedStyles: Set<String> = ["Modern", "Scandinavian", "Japandi"]
    private let allStyles = ["Modern", "Minimal", "Scandinavian", "Luxury", "Japandi", "Industrial"]

    private let avatarURL = URL(string:
        "https://lh3.googleusercontent.com/aida-public/AB6AXuAHxFj8qnrhrXgg5gxX50m4ISLKMUbIX7IzB-Vzz2E3xy9p05UH3_kuGJV4MxHLrs1axudbMvFDoRU-sHqX6CvpVu_oydm1GfvzN9_2juJLegddBqgukbynYe5mF_MpyCtJtVSxqBcDuNJzb_LlrWMBf9euRE7iKk_QfAa5mOHkziA0ZNVerjjDjaZ5Fvxm6I_J38wFjjd5yQUCcg9Dfp5Iy-GZ9ciNj_UHKj-vtRPnw5scPZa983He0g")

    var body: some View {
        VStack(spacing: 0) {
            profileHeader
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    identitySection
                    personalInfoSection
                    designPrefsSection
                    dangerZoneSection
                }
                .padding(.top, 24)
                .padding(.bottom, 120)
            }
        }
        .background(AppTheme.Colors.background.ignoresSafeArea())
    }

    // MARK: - Header
    private var profileHeader: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.primary)
                    .frame(width: 40, height: 40)
                    .background(AppTheme.Colors.surfaceContainerHigh.opacity(0.6))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text("My Profile")
                .font(.custom("Quicksand-SemiBold", size: 22))
                .foregroundColor(AppTheme.Colors.primary)

            Spacer()

            Button(action: {}) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.primary)
                    .frame(width: 40, height: 40)
                    .background(AppTheme.Colors.surfaceContainerHigh.opacity(0.6))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }

    // MARK: - Identity Section
    private var identitySection: some View {
        VStack(spacing: 20) {
            // Avatar
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: avatarURL) { img in
                    img.resizable().scaledToFill()
                } placeholder: {
                    AppTheme.Colors.surfaceContainerHigh
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(AppTheme.Colors.surfaceContainer, lineWidth: 4))
                .shadow(color: Color(hex: "#8C634F").opacity(0.2), radius: 20, y: 8)

                Button(action: {}) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.Colors.onSecondaryContainer)
                        .frame(width: 36, height: 36)
                        .background(AppTheme.Colors.secondaryContainer)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }
                .buttonStyle(.plain)
            }

            // Name + role
            VStack(spacing: 6) {
                Text("Mohit")
                    .font(.custom("Quicksand-SemiBold", size: 28))
                    .foregroundColor(AppTheme.Colors.primary)
                Text("AI Interior Designer")
                    .font(.custom("PlusJakartaSans-Regular", size: 15))
                    .foregroundColor(AppTheme.Colors.onSurfaceVariant)

                HStack(spacing: 6) {
                    Image(systemName: "star.fill").font(.system(size: 11)).foregroundColor(AppTheme.Colors.secondary)
                    Text("Premium Member").font(.custom("PlusJakartaSans-Medium", size: 12)).foregroundColor(AppTheme.Colors.secondary)
                }
                .padding(.horizontal, 14).padding(.vertical, 6)
                .background(AppTheme.Colors.surfaceContainerHigh)
                .clipShape(Capsule())
            }

            // Stats
            HStack(spacing: 12) {
                statCard("15",  "Rooms\nScanned")
                statCard("42",  "AI Designs\nGenerated")
                statCard("108", "Saved\nInspirations")
            }
            .padding(.horizontal, 20)
        }
    }

    private func statCard(_ value: String, _ label: String) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.custom("Quicksand-SemiBold", size: 26))
                .foregroundColor(AppTheme.Colors.primary)
            Text(label)
                .font(.custom("PlusJakartaSans-Medium", size: 12))
                .foregroundColor(AppTheme.Colors.onSurfaceVariant)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color(hex: "#8C634F").opacity(0.09), radius: 14, y: 4)
    }

    // MARK: - Personal Info
    private var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Personal Information")
                .font(AppTheme.Typography.headlineMd)
                .foregroundColor(AppTheme.Colors.primary)
                .padding(.horizontal, 20)

            VStack(spacing: 18) {
                profileField(icon: "person.fill",   label: "Full Name",    text: $fullName, keyType: .default)
                profileField(icon: "envelope.fill",  label: "Email",        text: $email,    keyType: .emailAddress)
                profileField(icon: "phone.fill",     label: "Phone Number", text: $phone,    keyType: .phonePad)
                HStack(spacing: 12) {
                    profileField(icon: "building.2.fill", label: "City",    text: $city,    keyType: .default)
                    profileField(icon: "globe",           label: "Country", text: $country, keyType: .default)
                }

                Button(action: {}) {
                    Text("Update Information")
                        .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                        .foregroundColor(AppTheme.Colors.onPrimaryContainer)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(AppTheme.Colors.primaryContainer)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: Color(hex: "#8C634F").opacity(0.09), radius: 20, y: 6)
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private func profileField(icon: String, label: String, text: Binding<String>, keyType: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.custom("PlusJakartaSans-SemiBold", size: 13))
                .foregroundColor(AppTheme.Colors.onSurfaceVariant)
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.Colors.outline)
                    .frame(width: 18)
                TextField(label, text: text)
                    .font(.custom("PlusJakartaSans-Regular", size: 15))
                    .foregroundColor(AppTheme.Colors.onSurface)
                    .keyboardType(keyType)
                    .textInputAutocapitalization(keyType == .emailAddress ? .never : .words)
                    .autocorrectionDisabled()
            }
            .padding(.horizontal, 14).padding(.vertical, 13)
            .background(AppTheme.Colors.surfaceContainer)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Design Preferences
    private var designPrefsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Design Preferences")
                .font(AppTheme.Typography.headlineMd)
                .foregroundColor(AppTheme.Colors.primary)
                .padding(.horizontal, 20)

            ProfileFlowLayout(spacing: 8) {
                ForEach(allStyles, id: \.self) { style in
                    let selected = selectedStyles.contains(style)
                    Button {
                        withAnimation(.spring(response: 0.25)) {
                            if selected { selectedStyles.remove(style) }
                            else        { selectedStyles.insert(style) }
                        }
                    } label: {
                        Text(style)
                            .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                            .foregroundColor(selected ? AppTheme.Colors.onPrimaryContainer : AppTheme.Colors.onSurfaceVariant)
                            .padding(.horizontal, 16).padding(.vertical, 9)
                            .background(selected ? AppTheme.Colors.primaryContainer : AppTheme.Colors.surface)
                            .overlay(Capsule().stroke(selected ? Color.clear : AppTheme.Colors.outlineVariant.opacity(0.5), lineWidth: 1))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Danger Zone
    private var dangerZoneSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Danger Zone")
                .font(AppTheme.Typography.headlineMd)
                .foregroundColor(AppTheme.Colors.error)
                .padding(.horizontal, 20)

            VStack(spacing: 0) {
                dangerRow(icon: "rectangle.portrait.and.arrow.right",
                          iconBg: AppTheme.Colors.surfaceContainerHigh,
                          iconFg: AppTheme.Colors.onSurfaceVariant,
                          label: "Sign Out",
                          labelColor: AppTheme.Colors.onSurface,
                          hoverBg: AppTheme.Colors.surfaceContainer)

                Divider().padding(.horizontal, 16)

                dangerRow(icon: "trash.fill",
                          iconBg: AppTheme.Colors.errorContainer,
                          iconFg: AppTheme.Colors.error,
                          label: "Delete Account",
                          labelColor: AppTheme.Colors.error,
                          hoverBg: AppTheme.Colors.errorContainer.opacity(0.5))
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: Color(hex: "#8C634F").opacity(0.09), radius: 20, y: 6)
            .padding(.horizontal, 20)
        }
    }

    private func dangerRow(icon: String, iconBg: Color, iconFg: Color,
                            label: String, labelColor: Color, hoverBg: Color) -> some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                ZStack {
                    Circle().fill(iconBg).frame(width: 42, height: 42)
                    Image(systemName: icon).font(.system(size: 16)).foregroundColor(iconFg)
                }
                Text(label)
                    .font(.custom("PlusJakartaSans-Medium", size: 16))
                    .foregroundColor(labelColor)
                Spacer()
            }
            .padding(16)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Flow Layout (chip wrapping)
struct ProfileFlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        layout(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(in: bounds.width, subviews: subviews)
        for (i, pt) in result.positions.enumerated() {
            subviews[i].place(at: CGPoint(x: bounds.minX + pt.x, y: bounds.minY + pt.y), proposal: .unspecified)
        }
    }

    private func layout(in maxW: CGFloat, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        var positions: [CGPoint] = []
        var x: CGFloat = 0, y: CGFloat = 0, rowH: CGFloat = 0, totalW: CGFloat = 0
        for sub in subviews {
            let sz = sub.sizeThatFits(.unspecified)
            if x + sz.width > maxW && x > 0 { y += rowH + spacing; x = 0; rowH = 0 }
            positions.append(CGPoint(x: x, y: y))
            x += sz.width + spacing
            rowH = max(rowH, sz.height)
            totalW = max(totalW, x)
        }
        return (positions, CGSize(width: totalW, height: y + rowH))
    }
}

#Preview {
    ProfileView()
}
