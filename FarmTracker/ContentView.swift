import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = true // change to false when login is ready

    var body: some View {
        NavigationView {
            if isAuthenticated {
                HomeView() 
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}
