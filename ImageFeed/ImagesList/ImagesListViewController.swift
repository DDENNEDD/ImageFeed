import UIKit

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

                guard let imageListCell = cell as? ImagesListCell else {
                    return UITableViewCell()
                }

                configCell(for: imageListCell) // 3
                return imageListCell // 4
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}


class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func configCell(for cell: ImagesListCell) { }
}

