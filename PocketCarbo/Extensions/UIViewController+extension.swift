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

  func setLeftNavigationBarBack() {
    self.removeNavigationBarItem()
    let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
    button.setImage(UIImage(named: "navigation_back_white"), for: UIControl.State.normal)
    button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
    button.frame =  CGRect(x: 0, y: 0, width: 36, height: 36)
    let barButton = UIBarButtonItem(customView: button)
    self.navigationItem.leftBarButtonItem = barButton
  }

  @objc
  func backButtonPressed(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
}

