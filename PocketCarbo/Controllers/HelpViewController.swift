//
//  HelpViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import Toaster

class HelpViewController: UIViewController, UIWebViewDelegate {

  @IBOutlet weak var webView: UIWebView!
  @IBOutlet weak var showTutorialButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    let htmlPath = Bundle.main.path(forResource: "help", ofType: "html")
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

  //MARK: Button Action

  @IBAction func didTapTutorial(_ sender: UIButton) {
    UserDefaults.standard.setShowTutorial(showTutorial: true)
    UserDefaults.standard.setTutorialShowing(tutorialShowing: false)
    let toastText = NSLocalizedString("Help.toast.tutorial", comment: "")
    Toast(text: toastText, duration: Delay.short).show()
  }
  
}
