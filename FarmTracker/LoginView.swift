import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("FarmTrack Login")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button("Log In") {
                loginUser()
            }
            .padding(.top, 10)
        }
        .padding()
    }

    func loginUser() {
        // TEMP: Skip login until your real API is hooked up
        if !email.isEmpty && !password.isEmpty {
            isAuthenticated = true
        } else {
            errorMessage = "Please enter email and password"
        }
    }
}
