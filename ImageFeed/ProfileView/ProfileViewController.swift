import UIKit

final class ProfileViewController: UIViewController {
    private var userProfileImageView: UIImageView?
    private var userNameLabel: UILabel?
    private var userLoginLabel: UILabel?
    private var userProfileDescriptionLabel: UILabel?
    private var userLogOutButton: UIButton?
    private let userProfileImage = UIImage(named: "UserProfileImage")
    private let userName = "Имя Пользователя"
    private let userLogin = "@Логин_Пользователя"
    private let userProfileDescription = "Описание профиля"

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addSubview()
        configConstaints()
    }

    private func initView() {
        let userProfileImageView = UIImageView(image: userProfileImage)
        userProfileImageView.contentMode = .scaleAspectFit
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.userProfileImageView = userProfileImageView

        let userNameLabel = UILabel()
        userNameLabel.text = userName
        userNameLabel.textColor = .ypWhite
        userNameLabel.font = .boldSystemFont(ofSize: 23)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userNameLabel = userNameLabel

        let userLoginLabel = UILabel()
        userLoginLabel.text = userLogin
        userLoginLabel.textColor = .ypGray
        userLoginLabel.font = .systemFont(ofSize: 13)
        userLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userLoginLabel = userLoginLabel

        let userProfileDescriptionLabel = UILabel()
        userProfileDescriptionLabel.text = userProfileDescription
        userProfileDescriptionLabel.textColor = .ypWhite
        userProfileDescriptionLabel.font = .systemFont(ofSize: 13)
        userProfileDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userProfileDescriptionLabel = userProfileDescriptionLabel

        let userLogOutButton = UIButton()
        let userLogOutButtonImage = UIImage(named: "iPadAndArrowForward")
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

    private func configConstaints() {
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
            userLogOutButton!.heightAnchor.constraint(equalToConstant: 22)])
    }
}
