import Foundation
import FirebaseCore
import FirebaseAuth
import Combine

// MARK: - Auth Manager
/// Centralised Firebase Auth state + operations.
/// Inject via `.environmentObject(AuthManager())` at the root.
@MainActor
final class AuthManager: ObservableObject {

    // MARK: Published state
    @Published var user: User?          // nil → not logged in
    @Published var isLoading  = false
    @Published var errorMessage: String?

    var isLoggedIn: Bool { user != nil }

    // MARK: Private
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        FirebaseApp.configure()
        // Listen to Firebase auth state changes (persists across app launches)
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }

    deinit {
        if let handle { Auth.auth().removeStateDidChangeListener(handle) }
    }

    // MARK: - Sign Up
    func signUp(email: String, password: String, fullName: String) async {
        guard validate(email: email, password: password) else { return }
        isLoading = true
        errorMessage = nil
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // Store display name
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = fullName
            try await changeRequest.commitChanges()
            user = Auth.auth().currentUser
        } catch {
            errorMessage = firebaseMessage(error)
        }
        isLoading = false
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) async {
        guard validate(email: email, password: password) else { return }
        isLoading = true
        errorMessage = nil
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            user = result.user
        } catch {
            errorMessage = firebaseMessage(error)
        }
        isLoading = false
    }

    // MARK: - Sign Out
    func signOut() {
        try? Auth.auth().signOut()
        user = nil
    }

    // MARK: - Password Reset
    func sendPasswordReset(email: String) async {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email address."
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            errorMessage = "Reset link sent! Check your inbox."
        } catch {
            errorMessage = firebaseMessage(error)
        }
        isLoading = false
    }

    // MARK: - Helpers
    private func validate(email: String, password: String) -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all required fields."
            return false
        }
        if !email.contains("@") {
            errorMessage = "Enter a valid email address."
            return false
        }
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        return true
    }

    private func firebaseMessage(_ error: Error) -> String {
        let err = error as NSError
        switch AuthErrorCode(rawValue: err.code) {
        case .emailAlreadyInUse:   return "This email is already registered."
        case .invalidEmail:        return "Invalid email address."
        case .wrongPassword:       return "Incorrect password."
        case .userNotFound:        return "No account found with this email."
        case .weakPassword:        return "Password is too weak. Use at least 6 characters."
        case .networkError:        return "Network error. Check your connection."
        default:                   return error.localizedDescription
        }
    }
}
