//
//  LeftTableViewCell.swift
//  ExamXLPagerTabStrip2
//
//  Created by Sakura on 2018/02/02.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

  @IBOutlet weak var icon: UIImageView!
  @IBOutlet weak var menuLabel: UILabel!

  func configureWithData(_ data: SideMenuData) {
    icon.image = data.icon
    menuLabel.text = data.menuLabel
  }
}
