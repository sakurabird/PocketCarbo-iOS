//
//  MainParentViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

class MainParentViewController: UIViewController {

  // MARK: - View life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    showAppMessageDialog()
    
    AppdStoreManager.sharedInstance.showReviewDialog()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.setNavigationBarItem()
    self.navigationController?.hidesBarsOnSwipe = true
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showTutorial()
  }

  // MARK: Functions

  func showTutorial() {
    if UserDefaults.standard.isTutorialShowing() || !UserDefaults.standard.isShowTutorial() {
      return
    }
    guard let viewController: TutorialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tutorial") as? TutorialViewController
      else {
        fatalError("The controller is not an instance of TutorialViewController.")
    }

    self.navigationController?.present(viewController, animated: true, completion: nil)
    UserDefaults.standard.setShowTutorial(showTutorial: false)
  }

  func showAppMessageDialog() {
    let lastMessageNo = UserDefaults.standard.getAppMessageNo()

    if UserDefaults.standard.isFirstLaunch() {
      UserDefaults.standard.setAppMessageNo(appMessageNo: Config.appMessageNo)
      return
    }

    if UserDefaults.standard.isTutorialShowing() {
      return
    }

    // Do not show dialog if already shown
    if Config.appMessageNo <= lastMessageNo {
      return
    }

    let title: String = NSLocalizedString("information", comment: "")
    let message: String = Config.appMessageText
    present(UIAlertController.alertWithTitle(title: title, message: message, buttonTitle: "OK"), animated: true, completion: nil)

    UserDefaults.standard.setAppMessageNo(appMessageNo: Config.appMessageNo)
  }

  // MARK: - Navigation

  @IBAction func unwindToMainParentViewController(segue: UIStoryboardSegue) {
  }

  @IBAction func didTapSearch(_ sender: UIBarButtonItem) {
    // 検索ボタンが押された
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    guard let vc: SearchViewController = storyboard.instantiateViewController(withIdentifier: "search") as? SearchViewController
      else {
        fatalError("The controller is not an instance of SearchViewController.")
    }
    let nv = UINavigationController(rootViewController: vc)

    self.present(nv, animated: true, completion: nil)
  }
}
