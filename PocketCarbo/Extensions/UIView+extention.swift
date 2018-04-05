//
//  UIButton+extention.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/04/05.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

@IBDesignable extension UIView {

  class func loadFromNibNamed(nibNamed: String, bundle: Bundle? = nil) -> UIView? {
    return UINib(
      nibName: nibNamed,
      bundle: bundle
      ).instantiate(withOwner: nil, options: nil)[0] as? UIView
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
