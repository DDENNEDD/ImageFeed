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
                if let token = OAuth2TokenStorage.shared.token {
                    DispatchQueue.main.async {
                        completion(.success(token))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.success(""))
                    }
                }
                return
            }
            self.task?.cancel()
            self.lastCode = code

            let request = self.authTokenRequest(code: code)
            self.task = self.urlSession.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                if let error = error {
                    DispatchQueue.main.async {
                        self.lastCode = nil
                        completion(.failure(error))
                    }
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        self.lastCode = nil
                        completion(.failure(NetworkError.urlSessionError))
                    }
                    return
                }
                guard 200 ..< 300 ~= httpResponse.statusCode else {
                    DispatchQueue.main.async {
                        self.lastCode = nil
                        completion(.failure(NetworkError.httpStatusCode(httpResponse.statusCode)))
                    }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(OAuthTokenResponseBody.self, from: data!)
                    let authToken = body.accessToken
                    OAuth2TokenStorage.shared.token = authToken
                    DispatchQueue.main.async {
                        completion(.success(authToken))
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.lastCode = nil
                        completion(.failure(error))
                    }
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
            "grant_type": "authorization_code"
        ]
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

extension URLSession {
    func dataTask(with request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) -> URLSessionTask {
        let task = dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(NetworkError.urlRequestError(error)))
                return
            }
            completion(.success(data))
        }
        return task
    }
}
