import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?

    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!

    @IBAction private func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }

    func setLike(like: Bool) {
        if like {
            likeButton.setImage(UIImage(named: "LikeButtonOn"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "LikeButtonOff"), for: .normal)
        }
    }
}
