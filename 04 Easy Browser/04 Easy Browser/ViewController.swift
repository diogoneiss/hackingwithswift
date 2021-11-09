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
    var progressView: UIProgressView!

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
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()

        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack)),
            UIBarButtonItem(customView: progressView),

            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),

            UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload)),
            UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward)),
        ]
        navigationController?.isToolbarHidden = false
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var decision: WKNavigationActionPolicy = .cancel
        defer { decisionHandler(decision) }

        guard let requestedHost: String = navigationAction.request.url?.host else {
            return
        }

        for allowedHost in websites.values {
            if allowedHost.contains(requestedHost) {
                decision = .allow
                break
            }
        }

        if decision == .cancel {
            😱(requestedHost)
        }
    }

    func 😱(_ host: String) {
        let alertController = UIAlertController(title: "Blocked URL", message: "\"\(host)\" is not in the allow list", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "k", style: .default, handler: nil))
        present(alertController, animated: true)
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
