//
//  UIButton+extention.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/24.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

extension UIButton {

  func animateCellButton(completion:@escaping ((Bool) -> Void)) {
    UIView.animate(withDuration: 0.1, animations: {
      self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) }, completion: { (finish: Bool) in
        UIView.animate(withDuration: 0.1, animations: {
          self.transform = CGAffineTransform.identity
          completion(finish)
        })
    })
  }
}
