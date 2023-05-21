// swiftlint: disable all
import Foundation

let AccessKey = "HnecKRVkkezqur4UPQdZtMwOLovEGMJH_fhUsFT8I5E"
let SecretKey = "PSMlx_vYdr992nYwwZIarCoXcHYCveNZ7eeVR1QM6_w"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let profilePath = "me"
let photosPath = "photos"

var DefaultBaseURL: URL {
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
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 defaultBaseURL: DefaultBaseURL,
                                 authURLString: unsplashAuthorizeURLString)
    }
}
