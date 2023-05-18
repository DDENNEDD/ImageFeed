import Foundation

//final class OAuth2TokenStorage {
//    var token: String? {
//        get {
//            UserDefaults.standard.string(forKey: "bearerToken")
//        }
//        set (newToken) {
//            UserDefaults.standard.set(newToken, forKey: "bearerToken")
//        }
//    }
//}

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()

    private let userDefaults = UserDefaults.standard
    private let tokenKey = "OAuth2Token"

    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.setValue(newValue, forKey: tokenKey)
        }
    }
}
