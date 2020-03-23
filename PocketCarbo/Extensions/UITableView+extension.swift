//
//  UITableView+extention.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/04/05.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

extension UITableView {

  func setEmptyView() {
    let view = UIView.loadFromNibNamed(nibNamed: "EmptyDataView")
    self.backgroundView = view
  }

  func restore() {
    self.backgroundView = nil
  }
}
