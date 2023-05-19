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
    let userLogin: String
    let userProfileDescription: String?
}

func fetchProfile(_ accessToken: String, completion: @escaping (Result<Profile, Error>) -> Void) {
    let url = URL(string: "https://api.unsplash.com/me")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            let error = NSError(domain: "Invalid response", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }

        guard let data = data else {
            let error = NSError(domain: "No data received", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }

        if httpResponse.statusCode == 200 {
            do {
                let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)

                let profile = Profile(userName: "\(profileResult.firstName) " + "\(profileResult.lastName)",
                                      userLogin: profileResult.userName,
                                      userProfileDescription: profileResult.bio)

                completion(.success(profile))
            } catch {
                completion(.failure(error))
            }
        } else {
            let error = NSError(domain: "Server Error", code: httpResponse.statusCode, userInfo: nil)
            completion(.failure(error))
        }
    }

    task.resume()
}
