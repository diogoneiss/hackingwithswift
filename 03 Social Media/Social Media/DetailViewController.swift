import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    var selectedImage: String?
    //var totalImages = 0
    //var imageIndex = 0
    var imageTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageTitle = imageTitle ?? selectedImage

        //title = selectedImage
        //title = "Picture \(imageIndex + 1) of \(totalim)"
        title = imageTitle
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        guard let selectedImage = selectedImage else { return }
        imageView.image = UIImage(named: selectedImage)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }

        let viewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(viewController, animated: true)
    }
}
