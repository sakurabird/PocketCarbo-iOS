//
//  MainViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MainViewController: ButtonBarPagerTabStripViewController {

  override func viewDidLoad() {
    setupPagerTabStrip()

    super.viewDidLoad()
  }

  //MARK: - Setup

  func setupPagerTabStrip() {
    // Important: XLPagerTabStrip Settings should be called before viewDidLoad is called.
    settings.style.buttonBarBackgroundColor = UIColor(rgb: 0xfafafa)
    settings.style.buttonBarItemBackgroundColor = UIColor(rgb: 0xfafafa)
    settings.style.selectedBarBackgroundColor = UIColor(rgb: 0xff6f00)
    settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
    settings.style.selectedBarHeight = 2.0
    settings.style.buttonBarItemTitleColor = UIColor(rgb: 0x757575)
    settings.style.buttonBarItemLeftRightMargin = 8
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemsShouldFillAvailableWidth = true
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0

    changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = UIColor(rgb: 0x757575)
      newCell?.label.textColor = UIColor(rgb: 0xff6f00)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  // MARK: - PagerTabStripDataSource

  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let types = TypeDataProvider.sharedInstance.findAll()
    var viewControllers: [UIViewController] = []

    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    for type in types {
      let vc = storyboard.instantiateViewController(withIdentifier: "Foods") as! FoodsTableViewController
      vc.setupTabData(indicatorInfo: IndicatorInfo(title: type.name), type: type)
      viewControllers.append(vc)
    }

    return viewControllers
  }
}

