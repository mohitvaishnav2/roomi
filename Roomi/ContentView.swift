import SwiftUI

// ContentView is the app entry point — delegates entirely to AppCoordinator.
struct ContentView: View {
    var body: some View {
        AppCoordinator()
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
}
