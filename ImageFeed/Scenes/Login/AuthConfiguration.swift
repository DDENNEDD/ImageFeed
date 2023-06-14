import Foundation

let unsplashAccessKey = "b6CX1RCFR51uWh3lf369p6iPaE8y81Dzvy-_a9m2eNI"
let unsplashSecretKey = "4iwE1TjomLp3InJoIZj2LvlOv-0Hq96VSbn_bvJy-kQ"
let unsplashRedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let unsplashAccessScope = "public+read_user+write_likes"
let profilePath = "me"
let photosPath = "photos"

var unsplashDefaultBaseURL: URL {
    guard let url = URL(string: "https://api.unsplash.com/") else {
        preconditionFailure("Unable to construct DefaultBaseURL")
    }
    return url
}

let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         defaultBaseURL: URL,
         authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }

    static var standard: AuthConfiguration {
        AuthConfiguration(accessKey: unsplashAccessKey,
                secretKey: unsplashSecretKey,
                redirectURI: unsplashRedirectURI,
                accessScope: unsplashAccessScope,
                defaultBaseURL: unsplashDefaultBaseURL,
                authURLString: unsplashAuthorizeURLString)
    }
}
