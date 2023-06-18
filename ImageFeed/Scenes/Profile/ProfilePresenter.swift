import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let webViewViewController = WebViewViewController()
    var profileService = ProfileService.shared

    func exit() {
        oAuth2TokenStorage.removeToken()
        WebViewViewController.clean()
        guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
        let newLogOnViewController = SplashViewController()
        window.rootViewController = newLogOnViewController
    }

    func getUrlForProfileImage() -> URL? {
        guard  let profileImageURL = ProfileImageService.shared.userProfileImageSmallURL,
               let url = URL(string: profileImageURL)  else { return nil }
        return url
    }

    func setUserProfileUI() {
        view?.profileName.text = profileService.profile?.name
        view?.profileContact.text = profileService.profile?.loginName
        view?.profileAbout.text = profileService.profile?.bio
        view?.configUI()
    }
}
