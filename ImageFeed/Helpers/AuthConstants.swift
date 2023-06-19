import Foundation

let unsplashAccessKey = "WO_3W1D81z4c4MlX09e_Q7gGLV0sB-tYTnKfozhzlig"
let unsplashSecretKey = "GokulK15gaiE4tvoN_HtqS49gJrTOEcQTy3rM-dg-nQ"
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
