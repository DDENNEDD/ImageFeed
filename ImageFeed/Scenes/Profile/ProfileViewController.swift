//import UIKit
//import Foundation
//
//private struct ProfileConstants {
//    static let userName = "Имя Пользователя"
//    static let userLogin = "@Логин_Пользователя"
//    static let userProfileDescription = "Описание профиля"
//    static let userProfileImage = UIImage(named: "UserProfileImage")
//    static let userLogOutButtonImage = UIImage(named: "iPadAndArrowForward")
//}
//
//final class ProfileViewController: UIViewController {
//    private var userProfileImageView: UIImageView?
//    private var userNameLabel: UILabel?
//    private var userLoginLabel: UILabel?
//    private var userProfileDescriptionLabel: UILabel?
//    private var userLogOutButton: UIButton?
//    private let profileService = ProfileService.shared
//    private var accessToken: String?
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        .lightContent
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initView()
//        addSubview()
//        configConstraints()
//        updateView()
//        print(profileService.profile?.userName)
//    }
//
//    private func initView() {
//        let userProfileImageView = UIImageView(image: ProfileConstants.userProfileImage)
//        userProfileImageView.contentMode = .scaleAspectFit
//        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
//        self.userProfileImageView = userProfileImageView
//
//        let userNameLabel = UILabel()
//        userNameLabel.text = ProfileConstants.userName
//        userNameLabel.textColor = .ypWhite
//        userNameLabel.font = .boldSystemFont(ofSize: 23)
//        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.userNameLabel = userNameLabel
//
//        let userLoginLabel = UILabel()
//        userLoginLabel.text = ProfileConstants.userLogin
//        userLoginLabel.textColor = .ypGray
//        userLoginLabel.font = .systemFont(ofSize: 13)
//        userLoginLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.userLoginLabel = userLoginLabel
//
//        let userProfileDescriptionLabel = UILabel()
//        userProfileDescriptionLabel.text = ProfileConstants.userProfileDescription
//        userProfileDescriptionLabel.textColor = .ypWhite
//        userProfileDescriptionLabel.font = .systemFont(ofSize: 13)
//        userProfileDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.userProfileDescriptionLabel = userProfileDescriptionLabel
//
//        let userLogOutButton = UIButton()
//        let userLogOutButtonImage = ProfileConstants.userLogOutButtonImage
//        userLogOutButton.contentMode = .scaleAspectFit
//        userLogOutButton.setImage(userLogOutButtonImage, for: .normal)
//        userLogOutButton.translatesAutoresizingMaskIntoConstraints = false
//        self.userLogOutButton = userLogOutButton
//    }
//
//    private func addSubview() {
//        view.addSubview(userProfileImageView ?? UIImageView())
//        view.addSubview(userNameLabel ?? UILabel())
//        view.addSubview(userLoginLabel ?? UILabel())
//        view.addSubview(userProfileDescriptionLabel ?? UILabel())
//        view.addSubview(userLogOutButton ?? UIButton())
//    }
//
//    private func configConstraints() {
//        NSLayoutConstraint.activate([
//            userProfileImageView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            userProfileImageView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
//            userProfileImageView!.widthAnchor.constraint(equalToConstant: 70),
//            userProfileImageView!.heightAnchor.constraint(equalToConstant: 70),
//            userNameLabel!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            userNameLabel!.topAnchor.constraint(equalTo: userProfileImageView!.bottomAnchor, constant: 8),
//            userLoginLabel!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            userLoginLabel!.topAnchor.constraint(equalTo: userNameLabel!.bottomAnchor, constant: 8),
//            userProfileDescriptionLabel!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            userProfileDescriptionLabel!.topAnchor.constraint(equalTo: userLoginLabel!.bottomAnchor, constant: 8),
//            userLogOutButton!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
//            userLogOutButton!.centerYAnchor.constraint(equalTo: userProfileImageView!.centerYAnchor),
//            userLogOutButton!.widthAnchor.constraint(equalToConstant: 20),
//            userLogOutButton!.heightAnchor.constraint(equalToConstant: 22)
//        ])
//    }
//
//    private func updateView() {
//        userNameLabel?.text = profileService.profile?.name
//        userLoginLabel?.text = profileService.profile?.loginName
//        userProfileDescriptionLabel?.text = profileService.profile?.bio
//        }
//}
import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func configUI()
    func showAlert()
    var profileName: UILabel { get set }
    var profileContact: UILabel { get set }
    var profileAbout: UILabel { get set }
    
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profilePhoto = UIImageView()
    var profileName = UILabel()
    var profileContact = UILabel()
    var profileAbout = UILabel()
    private let logOutButton = UIButton.systemButton(with: UIImage(named: "iPadAndArrowForward")!, target: nil, action: #selector(Self.didTapButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.accessibilityIdentifier = "logoutButton"
        
        presenter = ProfilePresenter()
        presenter?.view = self
        presenter?.setUserProfileUI()
        
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.DidChangeNotification, object: nil, queue: .main) {[weak self] _ in
            guard let self = self else { return }
            self.updateUserProfileImage()
        }
        updateUserProfileImage()
    }

    func configUI() {
        view.backgroundColor = .ypBlack
        let allViewOnScreen = [profilePhoto, profileName, profileContact, profileAbout, logOutButton]
        allViewOnScreen.forEach {view.addSubview($0)}
        allViewOnScreen.forEach {$0.translatesAutoresizingMaskIntoConstraints = false}
        profileName.font = UIFont.boldSystemFont(ofSize: 23)
        profileName.textColor = .ypWhite
        profileContact.font = UIFont.systemFont(ofSize: 13)
        profileContact.textColor = .ypGray
        profileAbout.font = UIFont.systemFont(ofSize: 13)
        profileAbout.textColor = .ypWhite
        logOutButton.tintColor = .ypRed

        NSLayoutConstraint.activate([
            profilePhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePhoto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profilePhoto.widthAnchor.constraint(equalToConstant: 70),
            profilePhoto.heightAnchor.constraint(equalToConstant: 70),
            profileName.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            profileName.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 8),
            profileAbout.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            profileAbout.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8),
            profileContact.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            profileContact.topAnchor.constraint(equalTo: profileAbout.bottomAnchor, constant: 8),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            logOutButton.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            logOutButton.widthAnchor.constraint(equalToConstant: 20),
            logOutButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    @objc
    private func didTapButton() {
        showAlert()
    }
}

extension ProfileViewController {
    func updateUserProfileImage() {
        guard let url = presenter?.getUrlForProfileImage() else { return  }
        let processor = RoundCornerImageProcessor(cornerRadius: 50, backgroundColor: .clear)
        profilePhoto.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        profilePhoto.kf.indicatorType = .activity
    }

    func showAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Да", style: .default) {[weak self] _ in
            guard let self = self else { return }
            self.presenter?.exit()
        }
        let actionNo = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        present(alert, animated: true)
        alert.view.accessibilityIdentifier = "exit"
    }
}

