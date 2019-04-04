//
//  WebViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/31.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var webView: WKWebView!
  
  var url: URL?
  var embed: Bool?
  var observeEstimatedProgress: NSKeyValueObservation?

  // MARK: - View life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    let request = URLRequest(url: url!)
    self.webView.navigationDelegate = self
    self.webView.load(request)
    self.webView.allowsBackForwardNavigationGestures = true
    self.observeKeysFowWebView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if embed! {
      // sidebar
      self.setNavigationBarItem()
    } else {
      // modal view
      self.setLeftNavigationBarBack()
    }
  }

  // MARK: - Setup

  func setUp(url: URL, embed: Bool) {
    self.url = url
    self.embed = embed
  }

  // MARK: - WKNavigationDelegate

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

    // リンクは全て外部ブラウザに飛ばす
    if navigationAction.navigationType == .linkActivated {
      if let url = navigationAction.request.url,
        UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
        decisionHandler(.cancel)
      } else {
        decisionHandler(.allow)
      }
    } else {
      // not a user click
      decisionHandler(.allow)
    }
  }

  func observeKeysFowWebView() {

    // WKWebView の estimatedProgress の値監視
    self.observeEstimatedProgress = self.webView.observe(\.estimatedProgress, options: [.new], changeHandler: { (webView, change) in
      self.progressView.alpha = 1.0
      self.progressView.setProgress(Float(change.newValue!), animated: true)

      if self.webView.estimatedProgress >= 1.0 {
        UIView.animate(withDuration: 0.3,
                       delay: 0.3,
                       options: [.curveEaseOut],
                       animations: { [weak self] in
                        self?.progressView.alpha = 0.0
          }, completion: { _ in
            self.progressView.setProgress(0.0, animated: false)
        })
      }
    })
  }
}
