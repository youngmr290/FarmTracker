import Foundation
import Security

class AuthService {
    static let shared = AuthService()

    private let baseURL = URL(string: "https://hub.farmoptimisation.com/api")!
    private let tokenKey = "FarmTrackerAccessToken"

    private init() {}

    // MARK: - Login

    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("v1/sign-in")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "password": password, "application": "MobTracker"]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(false, NSError(domain: "InvalidRequest", code: 0, userInfo: nil))
            return
        }
        request.httpBody = bodyData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error:", error)
                completion(false, error)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Response Code:", httpResponse.statusCode)
            }

            if let data = data, let bodyString = String(data: data, encoding: .utf8) {
                print("📦 Response Body:\n\(bodyString)")
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let token = json["accessToken"] as? String
            else {
                completion(false, NSError(domain: "LoginFailed", code: 0, userInfo: nil))
                return
            }

            self.storeToken(token)
            completion(true, nil)
        }.resume()
    }

    // MARK: - Token Handling

    func storeToken(_ token: String) {
        let data = Data(token.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary) // Replace if exists
        SecItemAdd(query as CFDictionary, nil)
    }

    func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
           let data = result as? Data,
           let token = String(data: data, encoding: .utf8) {
            return token
        }

        return nil
    }

    func logout() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey
        ]
        SecItemDelete(query as CFDictionary)
    }
}

