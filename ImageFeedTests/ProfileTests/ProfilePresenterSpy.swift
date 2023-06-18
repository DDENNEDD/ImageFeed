import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {

    var view: ImageFeed.ProfileViewControllerProtocol?
    var didExitCalled: Bool = false

    func setUserProfileUI() {
        view?.configUI()
    }

    func exit() {
        didExitCalled = true
    }

    func getUrlForProfileImage() -> URL? {
        return URL(string: "https://unsplash.com")
    }

    var profileService: ImageFeed.ProfileService

    init (profileService: ProfileService ) {
        self.profileService = profileService
    }

}
