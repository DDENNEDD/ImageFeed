import Foundation
@testable import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var viewDidLoadCalled: Bool = false
    var presenter: ImageFeed.WebViewPresenterProtocol?

    func load(request: URLRequest) {
        viewDidLoadCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}
