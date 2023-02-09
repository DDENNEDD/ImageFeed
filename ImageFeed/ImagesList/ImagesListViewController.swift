import UIKit

class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    private let photosName: [String] = Array(0..<20).map { "\($0)" }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func configCell(for cell: ImagesListCell) { }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

                guard let imageListCell = cell as? ImagesListCell else {
                    return UITableViewCell()
                }

                configCell(for: imageListCell)
                return imageListCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}
