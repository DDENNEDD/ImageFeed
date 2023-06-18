import Foundation

final class ImagesListService {

    private (set) var photos: [Photo] = []
    private let urlSession = URLSession.shared
    private var nextPage = 0
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private var likeTak: URLSessionTask?
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var page: Int?
    private var perPage = 10
    static let shared = ImagesListService()

    private func makePhoto(_ photoResult: [PhotoResult]) {
        for num in photoResult {
            guard let createdAt = num.createdAt else { return }
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: createdAt)
            let photo = Photo(id: num.id,
                              size: CGSize(width: Double(num.width),
                                           height: Double(num.height)),
                              createdAt: date,
                              welcomeDescription: num.welcomeDescription,
                              thumbImageURL: num.urls.thumb,
                              largeImageURL: num.urls.full,
                              isLiked: num.isLiked)
            photos.append(photo)
        }
    }

    private func changeLike (_ photoId: String) {
        if let index = photos.firstIndex(where: {$0.id == photoId}) {
            let photo = photos[index]
            let newPhoto = Photo(id: photo.id,
                                 size: photo.size,
                                 createdAt: photo.createdAt,
                                 welcomeDescription: photo.welcomeDescription,
                                 thumbImageURL: photo.thumbImageURL,
                                 largeImageURL: photo.largeImageURL,
                                 isLiked: !photo.isLiked)
            photos[index] = newPhoto
        }
    }

    func fetchPhotosNextPage() {
        nextPage += 1
        assert(Thread.isMainThread)
        task?.cancel()
        var request = URLRequest.makeHTTPRequest(path: "\(photosPath)?page=\(nextPage)&&per_page=\(perPage)",
                                                 httpMethod: "GET")
        if let token = oAuth2TokenStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let photosResult):
                    self.makePhoto(photosResult)
                    NotificationCenter.default.post(name: ImagesListService.DidChangeNotification,
                                                    object: self,
                                                    userInfo: ["photos": self.photos])
                case .failure(_):
                    break
                }
            }
        })
        self.task = task
        task.resume()
    }

    func changeLike(photoId: String,
                    isLike: Bool,
                    _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        likeTak?.cancel()
        if !isLike {
            var request = URLRequest.makeHTTPRequest(path: "\(photosPath)/\(photoId)/like", httpMethod: "POST")
            if let token = oAuth2TokenStorage.token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<PhotoLikeResult, Error>) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        self.changeLike(photoId)
                        completion(.success(()))
                    case .failure(let error):
                        assertionFailure("\(error)")
                        completion(.failure(error))
                    }
                }
            })
            self.likeTak = task
            task.resume()
        } else {
            var request = URLRequest.makeHTTPRequest(path: "\(photosPath)/\(photoId)/like", httpMethod: "DELETE")
            if let token = oAuth2TokenStorage.token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<PhotoLikeResult, Error>) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        self.changeLike(photoId)
                        completion(.success(()))
                    case .failure(let error):
                        assertionFailure("\(error)")
                        completion(.failure(error))
                    }
                }
            })
            self.likeTak = task
            task.resume()
        }
    }
}
