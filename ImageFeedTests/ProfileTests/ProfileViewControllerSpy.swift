import UIKit
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var profileName = UILabel()
    var profileContact = UILabel()
    var profileAbout = UILabel()
    var didMakeUICalled: Bool = false
    var presenter: ImageFeed.ProfilePresenterProtocol?

    func configUI() {
        didMakeUICalled = true
    }

    func showAlert() {
        presenter?.exit()
    }
}
