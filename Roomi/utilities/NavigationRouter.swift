import SwiftUI
import Observation

// MARK: - App Routes
enum AppRoute: Hashable {
    case onboard1, onboard2, onboard3
    case login, register
    case scanPrep, roomScanner, scanReview
    case aiDesignBrief, aiProcessing, aiResult
    case beforeAfter
    case styleSelection
    case colorsMaterials
    case furnitureRecommendations
    case arPlacement
    case measurements
    case projectDetails(projectID: String)
    case notifications
    case premium
    case editProfile
    case settings
    case helpAbout
    case savedInspirations
    case explore
    case search
    case projects
    case profile
}

// MARK: - Navigation Router
@Observable
final class NavigationRouter {
    var path = NavigationPath()

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
