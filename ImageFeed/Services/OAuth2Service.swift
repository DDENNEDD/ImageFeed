import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private let tokenQueue = DispatchQueue(label: "com.imageFeed-iOS.oauth2.tokenQueue")

    private var task: URLSessionTask?
    private var lastCode: String?

    func fetchOAuth2Token(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        tokenQueue.async { [weak self] in
            guard let self = self else { return }
            if self.lastCode == code {
                let token = OAuth2TokenStorage.shared.token ?? ""
                DispatchQueue.main.async {
                    completion(.success(token))
                }
                return
            }

            self.task?.cancel()
            self.lastCode = code
            let request = self.authTokenRequest(code: code)

            self.task = self.urlSession.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }

                var result: Result<String, Error>

                if let error = error {
                    result = .failure(error)
                } else if let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode {
                    do {
                        guard let data = data else {
                            throw NetworkError.urlSessionError
                        }
                        let decoder = JSONDecoder()
                        let body = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                        let authToken = body.accessToken
                        OAuth2TokenStorage.shared.token = authToken
                        result = .success(authToken)
                    } catch {
                        result = .failure(error)
                    }
                } else {
                    result = .failure(NetworkError.urlSessionError)
                }

                DispatchQueue.main.async {
                    self.lastCode = nil
                    completion(result)
                }
            }
            self.task?.resume()
        }
    }

    private func authTokenRequest(code: String) -> URLRequest {
        let parameters = [
            "client_id": accessKey,
            "client_secret": secretKey,
            "redirect_uri": redirectURI,
            "code": code,
            "grant_type": "authorization_code"]

        let urlString = baseURL.appendingPathComponent("/oauth/token").absoluteString
        var components = URLComponents(string: urlString)!
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        return request
    }
}

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
