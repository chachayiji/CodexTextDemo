import UIKit
import WebKit
import SnapKit

final class NewsDetailViewController: UIViewController {
  private let item: NewsItem
  private let webView: WKWebView
  private let activityIndicator = UIActivityIndicatorView(style: .large)

  init(item: NewsItem) {
    self.item = item
    let config = WKWebViewConfiguration()
    let source = """
    (function() {
      var meta = document.querySelector('meta[name=viewport]');
      if (!meta) {
        meta = document.createElement('meta');
        meta.name = 'viewport';
        document.head.appendChild(meta);
      }
      meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
      document.body.style.webkitTextSizeAdjust = '100%';
    })();
    """
    let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    config.userContentController.addUserScript(script)
    config.applicationNameForUserAgent = "Version/16.0 Mobile/15E148 Safari/604.1"
    self.webView = WKWebView(frame: .zero, configuration: config)
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = item.title
    view.backgroundColor = .systemBackground

    if let url = item.linkURL {
      configureWebView()
      configureActivityIndicator()
      webView.load(URLRequest(url: url))
    }
  }

  private func configureWebView() {
    webView.navigationDelegate = self
    view.addSubview(webView)

    webView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func configureActivityIndicator() {
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)

    activityIndicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }

}

extension NewsDetailViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    activityIndicator.stopAnimating()
  }

  func webView(
    _ webView: WKWebView,
    didFail navigation: WKNavigation!,
    withError error: Error
  ) {
    activityIndicator.stopAnimating()
  }

  func webView(
    _ webView: WKWebView,
    didFailProvisionalNavigation navigation: WKNavigation!,
    withError error: Error
  ) {
    activityIndicator.stopAnimating()
  }
}
