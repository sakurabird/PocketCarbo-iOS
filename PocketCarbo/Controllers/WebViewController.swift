//
//  WebViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/31.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var webView: UIWebView!
  
  var url: URL?
  var embed: Bool?

  func setUp(url: URL, embed: Bool) {
    self.url = url
    self.embed = embed
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    webView.delegate = self

    let request:URLRequest = URLRequest(url: url!)
    webView.loadRequest(request)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if embed! {
      // sidebar
      self.setNavigationBarItem()
    } else {
      // modal view
      self.removeNavigationBarItem()
      let button: UIButton = UIButton(type: UIButtonType.custom)
      button.setImage(UIImage(named: "navigation_back_white"), for: UIControlState.normal)
      button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
      button.frame =  CGRect(x: 0, y: 0, width: 36, height: 36)
      let barButton = UIBarButtonItem(customView: button)
      self.navigationItem.leftBarButtonItem = barButton
    }
  }

  @objc
  func backButtonPressed(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }

  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    self.progressView.alpha = 1

    switch navigationType {
    case .linkClicked:
      // Open links in Safari
      guard let url = request.url else { return true }

      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
        // openURL(_:) is deprecated in iOS 10+.
        UIApplication.shared.openURL(url)
      }
      return false
    default:
      return true
    }
  }

  func webViewDidStartLoad(_ webView: UIWebView) {
    self.progressView.setProgress(0.1, animated: false)
  }

  func webViewDidFinishLoad(_ webView: UIWebView) {
    self.progressView.setProgress(1.0, animated: true)
    self.progressView.alpha = 0
  }

  func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    self.progressView.setProgress(1.0, animated: true)
    self.progressView.alpha = 0
  }
}

