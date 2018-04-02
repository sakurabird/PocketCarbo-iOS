//
//  MainParentViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

class MainParentViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.setNavigationBarItem()
  }

  // MARK: - Navigation

  @IBAction func unwindToMainParentViewController(segue: UIStoryboardSegue) {
  }

  @IBAction func didTapSearch(_ sender: UIBarButtonItem) {
    // 検索ボタンが押された
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "Foods") as! FoodsTableViewController
    vc.navigationItem.title = NSLocalizedString("search", comment: "")
    vc.setupAllData()
    let nv = UINavigationController(rootViewController: vc)

    self.present(nv, animated: true, completion: nil)
  }
}

