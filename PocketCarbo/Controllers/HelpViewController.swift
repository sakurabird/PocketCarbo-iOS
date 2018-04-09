//
//  HelpViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import WebKit
import Toaster

class HelpViewController: UIViewController, WKNavigationDelegate {

  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var showTutorialButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    let htmlPath = Bundle.main.path(forResource: "help", ofType: "html")
    let url = URL(fileURLWithPath: htmlPath!)
    let request = URLRequest(url: url)
    webView.navigationDelegate = self
    webView.load(request)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNavigationBarItem()
  }

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

    // リンクは全て外部ブラウザに飛ばす
    if navigationAction.navigationType == .linkActivated  {
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

  //MARK: Button Action

  @IBAction func didTapTutorial(_ sender: UIButton) {
    UserDefaults.standard.setShowTutorial(showTutorial: true)
    UserDefaults.standard.setTutorialShowing(tutorialShowing: false)
    let toastText = NSLocalizedString("Help.toast.tutorial", comment: "")
    Toast(text: toastText, duration: Delay.short).show()
  }
  
}
