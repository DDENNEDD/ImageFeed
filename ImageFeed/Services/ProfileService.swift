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
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(ProfileServiceError.invalidResponse))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(ProfileServiceError.noDataReceived))
                }
                return
            }

            if httpResponse.statusCode == 200 {
                do {
                    let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)

                    let profile = Profile(userName: "\(profileResult.firstName) " + "\(profileResult.lastName)",
                                          userLogin: profileResult.userName,
                                          userProfileDescription: profileResult.bio)

                    DispatchQueue.main.async {
                        completion(.success(profile))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(ProfileServiceError.serverError(statusCode: httpResponse.statusCode)))
                }
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
