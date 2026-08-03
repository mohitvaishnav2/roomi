import SwiftUI

// MARK: - App Navigation Hub
/// Root view that wires all screens together via NavigationStack
struct ContentView: View {
    var body: some View {
        NavigationStack {
            // Start at Onboard 1 — the natural first screen
            Onboard1View()
                .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
