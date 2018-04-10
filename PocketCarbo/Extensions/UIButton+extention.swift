//
//  UIButton+extention.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/24.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

@IBDesignable extension UIButton {

  func animateCellButton(completion:@escaping ((Bool) -> Void)) {
    UIView.animate(withDuration: 0.1, animations: {
      self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) }, completion: { (finish: Bool) in
        UIView.animate(withDuration: 0.1, animations: {
          self.transform = CGAffineTransform.identity
          completion(finish)
        })
    })
  }

  @IBInspectable var borderWidth: CGFloat {
    set {
      layer.borderWidth = newValue
    }
    get {
      return layer.borderWidth
    }
  }

  @IBInspectable var cornerRadius: CGFloat {
    set {
      layer.cornerRadius = newValue
    }
    get {
      return layer.cornerRadius
    }
  }

  @IBInspectable var borderColor: UIColor? {
    set {
      guard let uiColor = newValue else { return }
      layer.borderColor = uiColor.cgColor
    }
    get {
      guard let color = layer.borderColor else { return nil }
      return UIColor(cgColor: color)
    }
  }
}
