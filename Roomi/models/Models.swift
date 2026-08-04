import SwiftUI
import Foundation

// MARK: - Room Type
enum RoomType: String, CaseIterable, Identifiable {
    case livingRoom = "Living Room"
    case bedroom = "Bedroom"
    case kitchen = "Kitchen"
    case bathroom = "Bathroom"
    case office = "Home Office"
    case diningRoom = "Dining Room"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .livingRoom: "sofa"
        case .bedroom: "bed.double"
        case .kitchen: "fork.knife"
        case .bathroom: "drop"
        case .office: "desktopcomputer"
        case .diningRoom: "table.furniture"
        }
    }
}

// MARK: - Design Style
enum DesignStyle: String, CaseIterable, Identifiable {
    case modern = "Modern"
    case scandinavian = "Scandinavian"
    case minimalist = "Minimalist"
    case bohemian = "Bohemian"
    case industrial = "Industrial"
    case midCentury = "Mid-Century"
    case coastal = "Coastal"
    case japandi = "Japandi"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .modern: "square.3.layers.3d"
        case .scandinavian: "leaf"
        case .minimalist: "minus.square"
        case .bohemian: "sparkles"
        case .industrial: "wrench.and.screwdriver"
        case .midCentury: "clock.arrow.circlepath"
        case .coastal: "water.waves"
        case .japandi: "mountain.2"
        }
    }

    var palette: [Color] {
        switch self {
        case .modern: [Color(hex: "#2C2C2C"), Color(hex: "#F5F5F5"), Color(hex: "#C8A96E")]
        case .scandinavian: [Color(hex: "#F0EBE3"), Color(hex: "#8B9467"), Color(hex: "#D4A853")]
        case .minimalist: [Color(hex: "#FFFFFF"), Color(hex: "#E8E8E8"), Color(hex: "#1A1A1A")]
        case .bohemian: [Color(hex: "#C4603C"), Color(hex: "#D4A853"), Color(hex: "#6B4C8A")]
        case .industrial: [Color(hex: "#4A4A4A"), Color(hex: "#8B7355"), Color(hex: "#C0C0C0")]
        case .midCentury: [Color(hex: "#D2691E"), Color(hex: "#8FBC8F"), Color(hex: "#F4A460")]
        case .coastal: [Color(hex: "#5B8DB8"), Color(hex: "#F5F0E8"), Color(hex: "#7FB3A8")]
        case .japandi: [Color(hex: "#8B7355"), Color(hex: "#F5F0E8"), Color(hex: "#4A5240")]
        }
    }

    var description: String {
        switch self {
        case .modern: "Clean lines, neutral palette, functional forms"
        case .scandinavian: "Warm wood, cozy textiles, functional simplicity"
        case .minimalist: "Less is more — intentional, serene, airy"
        case .bohemian: "Layered textures, global patterns, vibrant spirit"
        case .industrial: "Raw materials, exposed structure, urban edge"
        case .midCentury: "Organic shapes, bold tones, timeless retro"
        case .coastal: "Breezy blues, natural textures, relaxed living"
        case .japandi: "Japanese-Scandinavian harmony, wabi-sabi calm"
        }
    }
}

// MARK: - Room Measurements
struct RoomMeasurements {
    var width: Double
    var length: Double
    var height: Double

    var area: Double { width * length }
    var volume: Double { width * length * height }

    var formattedWidth: String { String(format: "%.1f m", width) }
    var formattedLength: String { String(format: "%.1f m", length) }
    var formattedHeight: String { String(format: "%.1f m", height) }
    var formattedArea: String { String(format: "%.1f m²", area) }
    var formattedVolume: String { String(format: "%.1f m³", volume) }
}

// MARK: - Room Project
struct RoomProject: Identifiable, Hashable {
    let id: String
    var name: String
    var roomType: RoomType
    var style: DesignStyle
    var createdAt: Date
    var isCompleted: Bool
    var measurements: RoomMeasurements?
    var gradientColors: [Color]

    static func == (lhs: RoomProject, rhs: RoomProject) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    static let sampleProjects: [RoomProject] = [
        RoomProject(
            id: "1", name: "Living Room Redesign", roomType: .livingRoom,
            style: .modern, createdAt: .now.addingTimeInterval(-86400 * 3),
            isCompleted: false,
            measurements: RoomMeasurements(width: 5.2, length: 7.8, height: 2.7),
            gradientColors: [Color(hex: "#DFC0B5"), Color(hex: "#F8D7CC")]
        ),
        RoomProject(
            id: "2", name: "Master Bedroom", roomType: .bedroom,
            style: .scandinavian, createdAt: .now.addingTimeInterval(-86400 * 7),
            isCompleted: true,
            measurements: RoomMeasurements(width: 4.5, length: 5.5, height: 2.7),
            gradientColors: [Color(hex: "#DBE1C0"), Color(hex: "#C4CAA9")]
        ),
        RoomProject(
            id: "3", name: "Home Office Setup", roomType: .office,
            style: .minimalist, createdAt: .now.addingTimeInterval(-86400 * 14),
            isCompleted: false,
            measurements: nil,
            gradientColors: [Color(hex: "#E7E1DE"), Color(hex: "#D3C3BE")]
        ),
        RoomProject(
            id: "4", name: "Dining Area", roomType: .diningRoom,
            style: .japandi, createdAt: .now.addingTimeInterval(-86400 * 21),
            isCompleted: true,
            measurements: RoomMeasurements(width: 3.8, length: 4.2, height: 2.7),
            gradientColors: [Color(hex: "#FEC9B1"), Color(hex: "#FDDBD0")]
        ),
    ]
}

// MARK: - Furniture Item
struct FurnitureItem: Identifiable {
    let id: String
    var name: String
    var category: FurnitureCategory
    var price: Double
    var brand: String
    var rating: Double
    var isRecommended: Bool
    var accentColor: Color

    enum FurnitureCategory: String, CaseIterable, Identifiable {
        case sofa = "Sofas"
        case table = "Tables"
        case chair = "Chairs"
        case bed = "Beds"
        case storage = "Storage"
        case lighting = "Lighting"
        case decor = "Décor"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .sofa: "sofa"
            case .table: "table.furniture"
            case .chair: "chair"
            case .bed: "bed.double"
            case .storage: "cabinet"
            case .lighting: "lamp.floor"
            case .decor: "photo.artframe"
            }
        }
    }

    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: price)) ?? "$\(Int(price))"
    }

    static let sampleItems: [FurnitureItem] = [
        FurnitureItem(id: "1", name: "Oslo Sectional Sofa", category: .sofa, price: 1899, brand: "Muuto", rating: 4.8, isRecommended: true, accentColor: Color(hex: "#DFC0B5")),
        FurnitureItem(id: "2", name: "Copenhagen Coffee Table", category: .table, price: 649, brand: "HAY", rating: 4.6, isRecommended: true, accentColor: Color(hex: "#DBE1C0")),
        FurnitureItem(id: "3", name: "Arc Floor Lamp", category: .lighting, price: 299, brand: "Flos", rating: 4.9, isRecommended: false, accentColor: Color(hex: "#FEC9B1")),
        FurnitureItem(id: "4", name: "Framed Accent Chair", category: .chair, price: 899, brand: "B&B Italia", rating: 4.7, isRecommended: true, accentColor: Color(hex: "#E7E1DE")),
        FurnitureItem(id: "5", name: "Linen Storage Cabinet", category: .storage, price: 549, brand: "IKEA x Hay", rating: 4.5, isRecommended: false, accentColor: Color(hex: "#C4CAA9")),
        FurnitureItem(id: "6", name: "Ceramic Table Lamp", category: .lighting, price: 189, brand: "Muuto", rating: 4.4, isRecommended: false, accentColor: Color(hex: "#FDDBD0")),
    ]
}

// MARK: - Inspiration Item
struct InspirationItem: Identifiable {
    let id: String
    var title: String
    var style: DesignStyle
    var isSaved: Bool
    var gradientColors: [Color]

    static let sampleItems: [InspirationItem] = [
        InspirationItem(id: "1", title: "Warm Nordic Living", style: .scandinavian, isSaved: true, gradientColors: [Color(hex: "#F0EBE3"), Color(hex: "#D4A853")]),
        InspirationItem(id: "2", title: "Urban Minimalist", style: .minimalist, isSaved: true, gradientColors: [Color(hex: "#E8E8E8"), Color(hex: "#1A1A1A")]),
        InspirationItem(id: "3", title: "Modern Sanctuary", style: .modern, isSaved: false, gradientColors: [Color(hex: "#2C2C2C"), Color(hex: "#C8A96E")]),
        InspirationItem(id: "4", title: "Bohemian Dreams", style: .bohemian, isSaved: true, gradientColors: [Color(hex: "#C4603C"), Color(hex: "#D4A853")]),
        InspirationItem(id: "5", title: "Japandi Serenity", style: .japandi, isSaved: false, gradientColors: [Color(hex: "#8B7355"), Color(hex: "#4A5240")]),
        InspirationItem(id: "6", title: "Coastal Retreat", style: .coastal, isSaved: true, gradientColors: [Color(hex: "#5B8DB8"), Color(hex: "#7FB3A8")]),
        InspirationItem(id: "7", title: "Mid-Century Revival", style: .midCentury, isSaved: false, gradientColors: [Color(hex: "#D2691E"), Color(hex: "#8FBC8F")]),
        InspirationItem(id: "8", title: "Industrial Loft", style: .industrial, isSaved: true, gradientColors: [Color(hex: "#4A4A4A"), Color(hex: "#8B7355")]),
    ]
}

// MARK: - App Notification
struct AppNotification: Identifiable {
    let id: String
    var title: String
    var body: String
    var type: NotificationType
    var date: Date
    var isRead: Bool

    enum NotificationType {
        case aiReady, projectUpdate, newInspiration, promo

        var icon: String {
            switch self {
            case .aiReady: "sparkles"
            case .projectUpdate: "folder.badge.plus"
            case .newInspiration: "photo.stack"
            case .promo: "star.circle"
            }
        }

        var color: Color {
            switch self {
            case .aiReady: AppTheme.Colors.primary
            case .projectUpdate: AppTheme.Colors.secondary
            case .newInspiration: AppTheme.Colors.tertiary
            case .promo: .orange
            }
        }
    }

    static let sampleNotifications: [AppNotification] = [
        AppNotification(id: "1", title: "Your AI design is ready!", body: "RoomIQ has finished generating your living room concepts.", type: .aiReady, date: .now.addingTimeInterval(-3600), isRead: false),
        AppNotification(id: "2", title: "Project updated", body: "Master Bedroom scan was successfully processed.", type: .projectUpdate, date: .now.addingTimeInterval(-86400), isRead: false),
        AppNotification(id: "3", title: "New inspiration added", body: "15 new Japandi style rooms added to Explore.", type: .newInspiration, date: .now.addingTimeInterval(-86400 * 2), isRead: true),
        AppNotification(id: "4", title: "Upgrade to Premium", body: "Unlock unlimited scans and AR placement.", type: .promo, date: .now.addingTimeInterval(-86400 * 3), isRead: true),
    ]
}

// MARK: - Color Swatch
struct ColorSwatch: Identifiable {
    let id: String
    var name: String
    var color: Color
    var hex: String
    var isSelected: Bool

    static let palettes: [[ColorSwatch]] = [
        [
            ColorSwatch(id: "w1", name: "Cloud White", color: Color(hex: "#F8F4F0"), hex: "#F8F4F0", isSelected: false),
            ColorSwatch(id: "w2", name: "Warm Cream", color: Color(hex: "#FEF8F4"), hex: "#FEF8F4", isSelected: false),
            ColorSwatch(id: "w3", name: "Linen", color: Color(hex: "#FAF0E6"), hex: "#FAF0E6", isSelected: false),
        ],
        [
            ColorSwatch(id: "n1", name: "Sage", color: Color(hex: "#8B9467"), hex: "#8B9467", isSelected: false),
            ColorSwatch(id: "n2", name: "Terracotta", color: Color(hex: "#C4603C"), hex: "#C4603C", isSelected: false),
            ColorSwatch(id: "n3", name: "Slate", color: Color(hex: "#5B8DB8"), hex: "#5B8DB8", isSelected: false),
        ],
        [
            ColorSwatch(id: "d1", name: "Charcoal", color: Color(hex: "#2C2C2C"), hex: "#2C2C2C", isSelected: false),
            ColorSwatch(id: "d2", name: "Espresso", color: Color(hex: "#4A2C17"), hex: "#4A2C17", isSelected: false),
            ColorSwatch(id: "d3", name: "Navy", color: Color(hex: "#1B2A4A"), hex: "#1B2A4A", isSelected: false),
        ],
    ]
}
