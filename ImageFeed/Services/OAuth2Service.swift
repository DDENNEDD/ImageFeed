//import Foundation
//
//final class OAuth2Service {
//
//    static let shared = OAuth2Service()
//    private let urlSession = URLSession.shared
//
//    private var task: URLSessionTask?
//    private var lastCode: String?
//
//    private (set) var authToken: String? {
//        get {
//            OAuth2TokenStorage().token
//        }
//        set {
//            OAuth2TokenStorage().token = newValue
//        }
//    }
//
//    func fetchOAuth2Token(_ code: String, completion: @escaping (Result<String, Error>) -> Void ) {
//
//        assert(Thread.isMainThread)
//        if lastCode == code { return }
//        task?.cancel()
//        lastCode = code
//
//        let request = authTokenRequest(code: code)
//        let task = object(for: request) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let body):
//                let authToken = body.accessToken
//                self.authToken = authToken
//                completion(.success(authToken))
//                self.task = nil
//            case .failure(let error):
//                self.lastCode = nil
//                self.task = nil
//                completion(.failure(error))
//            }
//        }
//        self.task = task
//        task.resume()
//    }
//}
//
//extension OAuth2Service {
//    private func object(
//        for request: URLRequest,
//        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
//    ) -> URLSessionTask {
//        let decoder = JSONDecoder()
//        return urlSession.data(for: request) { (result: Result<Data, Error>) in
//            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
//                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
//            }
//            completion(response)
//        }
//    }
//
//    private func authTokenRequest(code: String) -> URLRequest {
//        URLRequest.makeHTTPRequest(
//            path: "/oauth/token"
//            + "?client_id=\(accessKey)"
//            + "&&client_secret=\(secretKey)"
//            + "&&redirect_uri=\(redirectURI)"
//            + "&&code=\(code)"
//            + "&&grant_type=authorization_code",
//            httpMethod: "POST",
//            baseURL: baseURL
//        )
//    }
//
//    private struct OAuthTokenResponseBody: Decodable {
//        let accessToken: String
//        let tokenType: String
//        let scope: String
//        let createdAt: Int
//
//        enum CodingKeys: String, CodingKey {
//            case accessToken = "access_token"
//            case tokenType = "token_type"
//            case scope
//            case createdAt = "created_at"
//        }
//    }
//}
//
//extension URLRequest {
//    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = defaultBaseURL) -> URLRequest {
//        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
//        request.httpMethod = httpMethod
//        return request
//    }
//}
//
//enum NetworkError: Error {
//    case httpStatusCode(Int)
//    case urlRequestError(Error)
//    case urlSessionError
//}
//
//extension URLSession {
//    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
//        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//
//        let task = dataTask(with: request, completionHandler: { data, response, error in
//            if let data = data,
//               let response = response,
//               let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                if 200 ..< 300 ~= statusCode {
//                    fulfillCompletion(.success(data))
//                } else {
//                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
//                }
//            } else if let error = error {
//                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
//            } else {
//                fulfillCompletion(.failure(NetworkError.urlSessionError))
//            }
//        })
//        task.resume()
//        return task
//    }
//}
//import Foundation
//
//final class OAuth2Service {
//
//    static let shared = OAuth2Service()
//    private let urlSession = URLSession.shared
//    private let tokenQueue = DispatchQueue(label: "com.imageFeed.oauth2.tokenQueue")
//
//    private var task: URLSessionTask?
//    private var lastCode: String?
//
//    private var authToken: String? {
//        get {
//            return OAuth2TokenStorage.shared.token
//        }
//        set {
//            OAuth2TokenStorage.shared.token = newValue
//        }
//    }
//
//    func fetchOAuth2Token(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
//        assert(Thread.isMainThread)
//        tokenQueue.async { [weak self] in
//            guard let self = self else { return }
//            if self.lastCode == code {
//                DispatchQueue.main.async {
//                    completion(.success(self.authToken ?? ""))
//                }
//                return
//            }
//            self.task?.cancel()
//            self.lastCode = code
//
//            let request = self.authTokenRequest(code: code)
//            self.task = self.urlSession.dataTask(with: request) { [weak self] data, response, error in
//                guard let self = self else { return }
//                if let error = error {
//                    DispatchQueue.main.async {
//                        self.lastCode = nil
//                        completion(.failure(error))
//                    }
//                    return
//                }
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    DispatchQueue.main.async {
//                        self.lastCode = nil
//                        completion(.failure(NetworkError.urlSessionError))
//                    }
//                    return
//                }
//                guard 200 ..< 300 ~= httpResponse.statusCode else {
//                    DispatchQueue.main.async {
//                        self.lastCode = nil
//                        completion(.failure(NetworkError.httpStatusCode(httpResponse.statusCode)))
//                    }
//                    return
//                }
//                do {
//                    let decoder = JSONDecoder()
//                    let body = try decoder.decode(OAuthTokenResponseBody.self, from: data!)
//                    let authToken = body.accessToken
//                    self.authToken = authToken
//                    DispatchQueue.main.async {
//                        completion(.success(authToken))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        self.lastCode = nil
//                        completion(.failure(error))
//                    }
//                }
//            }
//            self.task?.resume()
//        }
//    }
//
//    private func authTokenRequest(code: String) -> URLRequest {
//        let parameters = [
//            "client_id": accessKey,
//            "client_secret": secretKey,
//            "redirect_uri": redirectURI,
//            "code": code,
//            "grant_type": "authorization_code"
//        ]
//        let urlString = baseURL.appendingPathComponent("/oauth/token").absoluteString
//        var components = URLComponents(string: urlString)!
//        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
//
//        var request = URLRequest(url: components.url!)
//        request.httpMethod = "POST"
//        return request
//    }
//}
//
//struct OAuthTokenResponseBody: Decodable {
//    let accessToken: String
//    let tokenType: String
//    let scope: String
//    let createdAt: Int
//
//    enum CodingKeys: String, CodingKey {
//        case accessToken = "access_token"
//        case tokenType = "token_type"
//        case scope
//        case createdAt = "created_at"
//    }
//}
//
//enum NetworkError: Error {
//    case httpStatusCode(Int)
//    case urlRequestError(Error)
//    case urlSessionError
//}
//
//struct OAuth2TokenStorage {
//    static var shared = OAuth2TokenStorage()
//    var token: String?
//}
//
//extension URLSession {
//    func dataTask(with request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) -> URLSessionTask {
//        let task = dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(NetworkError.urlRequestError(error)))
//                return
//            }
//            completion(.success(data))
//        }
//        return task
//    }
//}
import Foundation

final class OAuth2Service {

    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private let tokenQueue = DispatchQueue(label: "com.example.oauth2.tokenQueue")

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

//final class OAuth2TokenStorage {
//    static let shared = OAuth2TokenStorage()
//
//    private let userDefaults = UserDefaults.standard
//    private let tokenKey = "OAuth2Token"
//
//    var token: String? {
//        get {
//            return userDefaults.string(forKey: tokenKey)
//        }
//        set {
//            userDefaults.setValue(newValue, forKey: tokenKey)
//        }
//    }
//}

extension URLSession {
    func dataTask(with request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) -> URLSessionTask {
        let task = dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.urlRequestError(error)))
                return
            }
            completion(.success(data))
        }
        return task
    }
}
