import UIKit
import Foundation

private struct ProfileConstants {
    static let userName = "Имя Пользователя"
    static let userLogin = "@Логин_Пользователя"
    static let userProfileDescription = "Описание профиля"
    static let userProfileImage = UIImage(named: "UserProfileImage")
    static let userLogOutButtonImage = UIImage(named: "iPadAndArrowForward")
}

final class ProfileViewController: UIViewController {
    private var userProfileImageView: UIImageView?
    private var userNameLabel: UILabel?
    private var userLoginLabel: UILabel?
    private var userProfileDescriptionLabel: UILabel?
    private var userLogOutButton: UIButton?
    private let profileService = ProfileService()
    private var accessToken: String?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addSubview()
        configConstraints()
    }

    private func initView() {
        let userProfileImageView = UIImageView(image: ProfileConstants.userProfileImage)
        userProfileImageView.contentMode = .scaleAspectFit
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.userProfileImageView = userProfileImageView

        let userNameLabel = UILabel()
        userNameLabel.text = ProfileConstants.userName
        userNameLabel.textColor = .ypWhite
        userNameLabel.font = .boldSystemFont(ofSize: 23)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userNameLabel = userNameLabel

        let userLoginLabel = UILabel()
        userLoginLabel.text = ProfileConstants.userLogin
        userLoginLabel.textColor = .ypGray
        userLoginLabel.font = .systemFont(ofSize: 13)
        userLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userLoginLabel = userLoginLabel

        let userProfileDescriptionLabel = UILabel()
        userProfileDescriptionLabel.text = ProfileConstants.userProfileDescription
        userProfileDescriptionLabel.textColor = .ypWhite
        userProfileDescriptionLabel.font = .systemFont(ofSize: 13)
        userProfileDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userProfileDescriptionLabel = userProfileDescriptionLabel

        let userLogOutButton = UIButton()
        let userLogOutButtonImage = ProfileConstants.userLogOutButtonImage
        userLogOutButton.contentMode = .scaleAspectFit
        userLogOutButton.setImage(userLogOutButtonImage, for: .normal)
        userLogOutButton.translatesAutoresizingMaskIntoConstraints = false
        self.userLogOutButton = userLogOutButton
    }

    private func addSubview() {
        view.addSubview(userProfileImageView ?? UIImageView())
        view.addSubview(userNameLabel ?? UILabel())
        view.addSubview(userLoginLabel ?? UILabel())
        view.addSubview(userProfileDescriptionLabel ?? UILabel())
        view.addSubview(userLogOutButton ?? UIButton())
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            userProfileImageView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userProfileImageView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            userProfileImageView!.widthAnchor.constraint(equalToConstant: 70),
            userProfileImageView!.heightAnchor.constraint(equalToConstant: 70),
            userNameLabel!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userNameLabel!.topAnchor.constraint(equalTo: userProfileImageView!.bottomAnchor, constant: 8),
            userLoginLabel!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userLoginLabel!.topAnchor.constraint(equalTo: userNameLabel!.bottomAnchor, constant: 8),
            userProfileDescriptionLabel!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userProfileDescriptionLabel!.topAnchor.constraint(equalTo: userLoginLabel!.bottomAnchor, constant: 8),
            userLogOutButton!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            userLogOutButton!.centerYAnchor.constraint(equalTo: userProfileImageView!.centerYAnchor),
            userLogOutButton!.widthAnchor.constraint(equalToConstant: 20),
            userLogOutButton!.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

//    private func fetchProfileData() {
//        guard let accessToken = OAuth2TokenStorage.shared.token else {
//            print("No access token found")
//            return
//        }
//
//        profileService.fetchProfile(accessToken) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let profile):
//                    self?.updateView(with: profile)
//                case .failure(let error):
//                    print("Failed to fetch profile: \(error)")
//                }
//            }
//        }
//    }
//    private func updateView(with profile: Profile) {
//            userNameLabel?.text = profile.userName
//            userLoginLabel?.text = "@" + profile.userLogin
//            userProfileDescriptionLabel?.text = profile.userProfileDescription
//        }
}
