import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func configUI()
    func showAlert()
    var profileName: UILabel { get set }
    var profileContact: UILabel { get set }
    var profileAbout: UILabel { get set }

}
