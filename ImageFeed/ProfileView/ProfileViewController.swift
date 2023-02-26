import UIKit

class ProfileViewController: UIViewController {



    override func viewDidLoad() {
        super.viewDidLoad()

        let userProfileImage = UIImage(named: "UserProfileImage")
        let userProfileImageView = UIImageView(image: userProfileImage)
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userProfileImageView)
        userProfileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        userProfileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true

        let userName = UILabel()
        userName.text = "Имя Пользователя"
        userName.textColor = .ypWhite
        userName.font = .boldSystemFont(ofSize: 23)
        userName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userName)
        userName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        userName.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: 8).isActive = true



        let userLogin = UILabel()
        userLogin.text = "@Логин_Пользователя"
        userLogin.textColor = .ypGray
        userLogin.font = .systemFont(ofSize: 13)
        userLogin.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userLogin)
        userLogin.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        userLogin.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8).isActive = true




        let userProfileDescription = UILabel()
        userProfileDescription.text = "Описание профиля"
        userProfileDescription.textColor = .ypWhite
        userProfileDescription.font = .systemFont(ofSize: 13)
        userProfileDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userProfileDescription)
        userProfileDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        userProfileDescription.topAnchor.constraint(equalTo: userLogin.bottomAnchor, constant: 8).isActive = true

        let userLogOutButton = UIButton()
        let userLogOutButtonImage = UIImage(named: "iPadAndArrowForward")
        userLogOutButton.imageView?.contentMode = .scaleAspectFit
        userLogOutButton.setImage(userLogOutButtonImage, for: .normal)
        userLogOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userLogOutButton)
        userLogOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26).isActive = true
        userLogOutButton.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor).isActive = true
        userLogOutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        userLogOutButton.heightAnchor.constraint(equalToConstant: 22).isActive = true









    }

}
