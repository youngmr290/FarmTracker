import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var onLoginSuccess: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In to FarmTracker Pro")
                .font(.title)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            if isLoading {
                ProgressView()
            } else {
                Button("Login") {
                    login()
                }
                .padding()
            }
        }
        .padding()
    }

    private func login() {
        errorMessage = nil
        isLoading = true

        AuthService.shared.login(email: email, password: password) { success, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = error.localizedDescription
                } else if success {
                    print("✅ Login success — updating UI state")
                    onLoginSuccess()
                } else {
                    errorMessage = "Invalid credentials"
                }
            }
        }
    }
}
