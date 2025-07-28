import SwiftUI

struct ContentView: View {
    @AppStorage("isProUser") private var isProUser = false
    @State private var showingLogin = false

    var body: some View {
        Group {
            if isProUser {
                HomeView(showLogin: { showingLogin = true })
            } else if showingLogin {
                LoginView {
                    isProUser = true
                    showingLogin = false
                    print("✅ Switched to Pro Mode from Login")
                }
            } else {
                HomeView(showLogin: { showingLogin = true })
            }
        }
        .onAppear {
            // 🧠 Check token at launch to auto-set isProUser
            if AuthService.shared.getToken() != nil {
                print("🔁 Found token in Keychain — auto-logging in")
                isProUser = true
            } else {
                print("🔓 No token found — using free mode")
            }
        }
    }
}
