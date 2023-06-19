import Foundation

let unsplashAccessKey = "74BTGIkVndHBUTTPDXj6IHDnZAL9qOCVXUMneh95Beg"
let unsplashSecretKey = "zaoAR42l2P4mBFJZyGZpKvg1yR8Eh02CWY0jWLUcV0A"
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
