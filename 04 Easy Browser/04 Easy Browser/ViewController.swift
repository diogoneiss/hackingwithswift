import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    let websites: [String: String] = [
        "The Zig Programming Language": "https://ziglang.org",
        "The Odin Programming Language": "https://odin-lang.org/",
        "xkcd": "https://xkcd.com/",
        "Linux Foundation": "https://www.linuxfoundation.org/",
        "As The Dice Roll": "https://asthedicerollcast.com/",
    ]

    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://ziglang.org")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    @objc func openTapped() {
        let alertController = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)

        websites.keys.sorted().forEach({
            alertController.addAction(UIAlertAction(title: $0, style: .default, handler: openPage))
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem

        present(alertController, animated: true)
    }

    @objc func openPage(action: UIAlertAction) {
        guard let requestUrl = websites[action.title!] else { return }
        let httpsUrl = requestUrl.hasPrefix("https://") ? requestUrl : "https://" + requestUrl
        let url = URL(string: httpsUrl)!

        webView.load(URLRequest(url: url))
    }
}
