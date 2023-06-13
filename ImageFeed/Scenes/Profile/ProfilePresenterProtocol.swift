import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func exit()
    func setUserProfileUI()
    func getUrlForProfileImage() -> URL?
    var profileService: ProfileService { get }
}
