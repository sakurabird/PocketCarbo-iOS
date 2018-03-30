//
//  MainViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DropDown

class MainViewController: ButtonBarPagerTabStripViewController {

  var tabControllers: [UIViewController]?

  let kindsDropDown = DropDown()
  let sortDropDown = DropDown()

  @IBOutlet weak var kindSelectButton: UIButton!
  @IBOutlet weak var sortSelectButton: UIButton!
  
  override func viewDidLoad() {
    setupPagerTabStrip()

    super.viewDidLoad()

    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "main_bg")!)

  }

  //MARK: - Setup

  func setupPagerTabStrip() {
    // Important: XLPagerTabStrip Settings should be called before viewDidLoad is called.

    settings.style.buttonBarBackgroundColor = UIColor(rgb: 0xfafafa)
    settings.style.buttonBarItemBackgroundColor = UIColor(rgb: 0xfafafa)
    settings.style.selectedBarBackgroundColor = UIColor(rgb: 0xff6f00)
    settings.style.selectedBarHeight = 4.0
    settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
    settings.style.buttonBarItemTitleColor = UIColor(rgb: 0x757575)
    settings.style.buttonBarItemLeftRightMargin = 8
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemsShouldFillAvailableWidth = true
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0

    changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = UIColor(rgb: 0x757575)
      newCell?.label.textColor = UIColor(rgb: 0xff6f00)
    }
  }

  //MARK: - Setup DropDown Buttons

  private func setupDropDowns() {
    kindsDropDown.anchorView = kindSelectButton
    sortDropDown.anchorView = sortSelectButton

    kindsDropDown.dismissMode = .onTap
    sortDropDown.dismissMode = .onTap
    kindsDropDown.direction = .any
    sortDropDown.direction = .any

    setupKindsDataSource()

    // TODO
    sortDropDown.dataSource = ["Car", "Motorcycle", "Truck","あああ"]
    // Action triggered on selection
    sortDropDown.selectionAction = { [weak self] (index, item) in
      self?.sortSelectButton.setTitle(item, for: .normal)
    }
  }

  private func setupKindsDataSource() {

    let foodsTableViewController = tabControllers![currentIndex] as! FoodsTableViewController
    let kinds = foodsTableViewController.kinds

    kindSelectButton.setTitle(foodsTableViewController.selectedKind.name, for: .normal)

    let kindAll = Kind()
    kindAll.id = 0
    kindAll.name = NSLocalizedString("Foods.dropdown.all", comment: "")

    var kindDatasource = [String]()
    kindDatasource.append(kindAll.name!)
    for kind in kinds! {
      kindDatasource.append(kind.name!)
    }

    kindsDropDown.dataSource = kindDatasource

    // Action triggered on selection
    kindsDropDown.selectionAction = { [weak self] (index, item) in

      if index == 0 {
        foodsTableViewController.extractKindData(kind: kindAll)
      } else {
        let kind = kinds![index - 1]
        foodsTableViewController.extractKindData(kind: kind)
      }
      self?.kindSelectButton.setTitle(item, for: .normal)
    }
  }

  // MARK: - PagerTabStripDataSource

  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let types = TypeDataProvider.sharedInstance.findAll()

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    tabControllers = [UIViewController]()

    for type in types {
      let vc = storyboard.instantiateViewController(withIdentifier: "Foods") as! FoodsTableViewController
      vc.setupTabData(indicatorInfo: IndicatorInfo(title: type.name), type: type)
      tabControllers?.append(vc)
    }
    setupDropDowns()

    return tabControllers!
  }

  override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
    super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)

    if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
      // Kind dropdown refresh
      setupKindsDataSource()
    }
  }

  // MARK: - Button Actions

  @IBAction func disTapKind(_ sender: UIButton) {
    kindsDropDown.show()
  }

  @IBAction func didTapSort(_ sender: UIButton) {
    sortDropDown.show()
  }
}

