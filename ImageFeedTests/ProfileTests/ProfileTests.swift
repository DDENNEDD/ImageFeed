import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {

    func testGetUrlForProfileImage() {
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let url = presenter.getUrlForProfileImage()?.absoluteString
        XCTAssertEqual(url, "https://unsplash.com")
    }

    func testExitFromProfile() {
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy()
        view.presenter = presenter
        presenter.view = view
        view.showAlert()
        XCTAssertTrue(presenter.didExitCalled)
    }

    func testLoadProfileInfo() {
        let profileService = ProfileService()
        let view = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        view.presenter = presenter
        presenter.view = view
        presenter.setUserProfileUI()
        XCTAssertTrue(view.didMakeUICalled)
    }
}
