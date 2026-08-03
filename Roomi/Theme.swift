import SwiftUI

/// App-wide theme tokens matching the HTML design system
enum AppTheme {
    // MARK: - Colors
    struct Colors {
        // Primary palette
        static let primary           = Color(hex: "#715950")
        static let primaryContainer  = Color(hex: "#F8D7CC")
        static let onPrimary         = Color.white
        static let onPrimaryContainer = Color(hex: "#755C54")
        static let primaryFixed      = Color(hex: "#FDDBD0")
        static let primaryFixedDim   = Color(hex: "#DFC0B5")

        // Secondary palette
        static let secondary          = Color(hex: "#7C5542")
        static let secondaryContainer = Color(hex: "#FEC9B1")
        static let onSecondary        = Color.white
        static let onSecondaryContainer = Color(hex: "#79523F")

        // Tertiary palette
        static let tertiary           = Color(hex: "#5B6147")
        static let tertiaryContainer  = Color(hex: "#DBE1C0")
        static let onTertiary         = Color.white

        // Surface / Background
        static let background         = Color(hex: "#FEF8F4")
        static let surface            = Color(hex: "#FEF8F4")
        static let surfaceContainer   = Color(hex: "#F3EDE9")
        static let surfaceContainerLow   = Color(hex: "#F8F2EF")
        static let surfaceContainerHigh  = Color(hex: "#EDE7E3")
        static let surfaceContainerLowest = Color(hex: "#FFFFFF")
        static let surfaceVariant     = Color(hex: "#E7E1DE")
        static let surfaceDim         = Color(hex: "#DED9D5")

        // On surface
        static let onSurface          = Color(hex: "#1D1B19")
        static let onSurfaceVariant   = Color(hex: "#4F4441")

        // Outline
        static let outline            = Color(hex: "#817470")
        static let outlineVariant     = Color(hex: "#D3C3BE")

        // Additional surface tokens
        static let surfaceContainerHighest = Color(hex: "#E7E1DE")

        // On-color extras
        static let onTertiaryContainer = Color(hex: "#5E6449")
        static let onError             = Color.white

        // Peach brand (Onboarding screens)
        static let peach              = Color(hex: "#F5B7A6")
        static let peachLight         = Color(hex: "#FDEEEA")
        static let brandPeach         = Color(hex: "#F4BCA9")
        static let brandBg            = Color(hex: "#FAF5F1")

        // Error
        static let error              = Color(hex: "#BA1A1A")
        static let errorContainer     = Color(hex: "#FFDAD6")
    }

    // MARK: - Typography
    // Using explicit PostScript weight-named faces to avoid "Unable to update
    // Font Descriptor's weight" simulator warnings. Falls back gracefully to
    // the system font if the custom font isn't bundled.
    struct Typography {
        static let displayLg        = Font.custom("Quicksand-Bold",      size: 48)
        static let headlineLg       = Font.custom("Quicksand-SemiBold",  size: 32)
        static let headlineLgMobile = Font.custom("Quicksand-SemiBold",  size: 28)
        static let headlineMd       = Font.custom("Quicksand-SemiBold",  size: 24)
        static let bodyLg           = Font.custom("PlusJakartaSans-Regular",  size: 18)
        static let bodyMd           = Font.custom("PlusJakartaSans-Regular",  size: 16)
        static let labelMd          = Font.custom("PlusJakartaSans-SemiBold", size: 14)
        static let labelSm          = Font.custom("PlusJakartaSans-Medium",   size: 12)
    }

    // MARK: - Corner Radii
    struct Radius {
        static let small:  CGFloat = 4
        static let medium: CGFloat = 8
        static let large:  CGFloat = 12
        static let xl:     CGFloat = 16
        static let xxl:    CGFloat = 24
        static let full:   CGFloat = 999
    }
}

// MARK: - Color init from hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red:   Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
