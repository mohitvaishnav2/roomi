import SwiftUI

// MARK: - User Profile
struct UserProfile {
    var id: String
    var name: String
    var email: String
    var bio: String
    var location: String
    var joinDate: Date

    static let preview = UserProfile(
        id: UUID().uuidString,
        name: "Alex Johnson",
        email: "alex@example.com",
        bio: "Interior design enthusiast & home renovation addict.",
        location: "San Francisco, CA",
        joinDate: Calendar.current.date(byAdding: .month, value: -3, to: .now) ?? .now
    )
}

// MARK: - Auth Manager
@MainActor
final class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: UserProfile? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            try await Task.sleep(for: .seconds(1.5))
            isAuthenticated = true
            currentUser = UserProfile(
                id: UUID().uuidString,
                name: "Alex Johnson",
                email: email,
                bio: "Interior design enthusiast & home renovation addict.",
                location: "San Francisco, CA",
                joinDate: Calendar.current.date(byAdding: .month, value: -3, to: .now) ?? .now
            )
        } catch {
            errorMessage = "Sign in failed. Please try again."
        }
        isLoading = false
    }

    func signUp(name: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            try await Task.sleep(for: .seconds(1.5))
            isAuthenticated = true
            currentUser = UserProfile(
                id: UUID().uuidString,
                name: name,
                email: email,
                bio: "",
                location: "",
                joinDate: .now
            )
        } catch {
            errorMessage = "Registration failed. Please try again."
        }
        isLoading = false
    }

    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }
}
