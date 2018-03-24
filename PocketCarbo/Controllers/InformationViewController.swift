//
//  InformationViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController, UIWebViewDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()

    let webView:UIWebView = UIWebView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))

    self.view.addSubview(webView)

    webView.delegate = self

    let htmlPath = Bundle.main.path(forResource: "announcement", ofType: "html")
    let url = URL(fileURLWithPath: htmlPath!)
    let request:URLRequest = URLRequest(url: url)
    webView.loadRequest(request)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNavigationBarItem()
  }
  
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
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

}

