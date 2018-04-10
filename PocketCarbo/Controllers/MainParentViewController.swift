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

    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tutorial") as! TutorialViewController
    self.navigationController?.present(viewController, animated: true, completion: nil)
    UserDefaults.standard.setShowTutorial(showTutorial: false)
  }

  // MARK: - Navigation

  @IBAction func unwindToMainParentViewController(segue: UIStoryboardSegue) {
  }

  @IBAction func didTapSearch(_ sender: UIBarButtonItem) {
    // 検索ボタンが押された
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "search") as! SearchViewController
    let nv = UINavigationController(rootViewController: vc)

    self.present(nv, animated: true, completion: nil)
  }
}

