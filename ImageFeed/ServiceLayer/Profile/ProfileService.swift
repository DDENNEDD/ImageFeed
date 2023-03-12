import UIKit

final class ProfileService {

}

struct ProfileResult: Codable {
    let userName: String
    let firstName: String
    let lastName: String
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    let userName: String
    let firstName: String
    let lastName: String
    let bio: String?
}

func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {

}
