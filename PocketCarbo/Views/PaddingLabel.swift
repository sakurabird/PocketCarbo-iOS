//
//  PaddingLabel.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/09/21.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

@IBDesignable class PaddingLabel: UILabel {

  @IBInspectable var topInset: CGFloat = 5.0
  @IBInspectable var bottomInset: CGFloat = 5.0
  @IBInspectable var leftInset: CGFloat = 7.0
  @IBInspectable var rightInset: CGFloat = 7.0

  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }

  @IBInspectable var borderColor: UIColor? {
    get {
      guard let color = layer.borderColor else { return nil }
      return UIColor(cgColor: color)
    }
    set {
      guard let uiColor = newValue else { return }
      layer.borderColor = uiColor.cgColor
    }
  }

  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)))
  }

  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + leftInset + rightInset,
                  height: size.height + topInset + bottomInset)
  }
}
