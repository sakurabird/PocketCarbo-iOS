//
//  Notification+extention.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

extension UIViewController {

  func setNavigationBarItem() {
    self.addLeftBarButtonWithImage(UIImage(named: "navigation_menu")!)
    self.slideMenuController()?.removeLeftGestures()
    self.slideMenuController()?.addLeftGestures()
  }

  func removeNavigationBarItem() {
    self.navigationItem.leftBarButtonItem = nil
    self.slideMenuController()?.removeLeftGestures()
  }
}

