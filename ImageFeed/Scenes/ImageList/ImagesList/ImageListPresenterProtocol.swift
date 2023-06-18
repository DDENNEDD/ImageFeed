import Foundation

protocol ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListService { get }
    func fetchPhotosNextPage()
    func chekFilledList(_ indexPath: IndexPath)
    func setLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}
