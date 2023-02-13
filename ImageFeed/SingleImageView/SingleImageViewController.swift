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
    
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        imageView.image = image
        }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
} 
