//
//  UIAlertController+extension.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/31.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
extension UIAlertController {

  static func alertWithTitle(title: String, message: String, buttonTitle: String) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
    alertController.addAction(action)

    return alertController
  }
}
