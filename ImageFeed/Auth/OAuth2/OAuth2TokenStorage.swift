import Foundation

final class OAuth2TokenStorage {
    var token: String? {
            get {
                UserDefaults.standard.string(forKey: "bearerToken")
            }
            set (newToken) {
                UserDefaults.standard.set(newToken, forKey: "bearerToken")
            }
        }
    }
