//
//  UIButton+extention.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/04/05.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

extension UIView {

  class func loadFromNibNamed(nibNamed: String, bundle: Bundle? = nil) -> UIView? {
    return UINib(
      nibName: nibNamed,
      bundle: bundle
      ).instantiate(withOwner: nil, options: nil)[0] as? UIView
  }
}
