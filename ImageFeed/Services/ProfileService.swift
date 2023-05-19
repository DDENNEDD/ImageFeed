import UIKit

final class ProfileService {
    private struct ProfileResult: Codable {
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

    private func profileRequest(with accessToken: String) -> URLRequest {
        let url = URL(string: "\(defaultBaseURL)/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }

    func fetchProfile(_ accessToken: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = profileRequest(with: accessToken)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ProfileServiceError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(ProfileServiceError.noDataReceived))
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
                completion(.failure(ProfileServiceError.serverError(statusCode: httpResponse.statusCode)))
            }
        }

        task.resume()
    }
}

struct Profile {
    let userName: String
    let userLogin: String
    let userProfileDescription: String?
}

enum ProfileServiceError: Error {
    case invalidResponse
    case noDataReceived
    case serverError(statusCode: Int)
}
