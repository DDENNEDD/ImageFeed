import XCTest
@testable import ImageFeed

final class ImageListTests: XCTestCase {

    func testSetLike () {
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImageListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        view.setLike()
        XCTAssertTrue(presenter.didSetLikeCallSuccess)
    }

    func testLoadPhotoToTable1() {
        let tableView = UITableView()
        let tableCell = UITableViewCell()
        let indexPath: IndexPath = IndexPath(row: 2, section: 2)
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImageListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        view.tableView(tableView, willDisplay: tableCell, forRowAt: indexPath)
        XCTAssertTrue(presenter.didFetchPhotosCalled)
    }
}
