//
//  ViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/21.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    print("viewDidLoad")
    NotificationCenter.default.observeEvent(observer: self, selector: #selector(ViewController.dataUpdated), notification: NotificationEvent.foodsAndKindsUpdated)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @objc func dataUpdated(notification: NSNotification) {
    print("TODO: table refresh")
  }
}

