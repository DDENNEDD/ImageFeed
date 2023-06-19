import UIKit

protocol ImagesListViewControllerProtocol {
    var presenter: ImageListPresenterProtocol? { get set }
    var photos: [Photo] { get set }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}
