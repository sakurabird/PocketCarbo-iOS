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

}

