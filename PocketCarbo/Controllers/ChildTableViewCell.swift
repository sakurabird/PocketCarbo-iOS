//
//  ChildTableViewCell.swift
//  ExamXLPagerTabStrip2
//
//  Created by Sakura on 2018/01/27.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

class ChildTableViewCell: UITableViewCell {

  @IBOutlet weak var label1: UILabel!
  @IBOutlet weak var label2: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  func configureWithData(_ data: CellData) {
    label1.text = data.label1
    label2.text = data.label2
  }
}
