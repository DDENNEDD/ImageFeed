import UIKit

class SingleImageViewController: UIViewController {
    var image: UIImage! {
            didSet {
                guard isViewLoaded else { return }
                imageView.image = image
            }
        }

    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
            super.viewDidLoad()
            imageView.image = image
        }
}
