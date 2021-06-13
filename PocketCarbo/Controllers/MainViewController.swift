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
import Toaster

class MainViewController: ButtonBarPagerTabStripViewController {

  var tabControllers: [UIViewController]?

  let kindsDropDown = DropDown()
  let sortDropDown = DropDown()

  @IBOutlet weak var kindSelectButton: UIButton!
  @IBOutlet weak var sortSelectButton: UIButton!

  override func viewDidLoad() {
    setupPagerTabStrip()

    super.viewDidLoad()
  }

  // MARK: - Setup

  func setupPagerTabStrip() {
    // Important: XLPagerTabStrip Settings should be called before viewDidLoad is called.

    settings.style.buttonBarBackgroundColor = UIColor(named: "ColorTabBackground")
    settings.style.buttonBarItemBackgroundColor = UIColor(named: "ColorTabBackground")
    settings.style.selectedBarBackgroundColor = UIColor(named: "ColorAccent")!
    settings.style.selectedBarHeight = 4.0
    settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
    settings.style.buttonBarItemTitleColor = UIColor(named: "ColorTextGrayDark")
    settings.style.buttonBarItemLeftRightMargin = 8
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemsShouldFillAvailableWidth = true
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0

    changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _ progressPercentage: CGFloat, changeCurrentIndex: Bool, _ animated: Bool) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = UIColor(named: "ColorTextGrayDark")
      newCell?.label.textColor = UIColor(named: "ColorAccent")
    }
  }

  // MARK: - Setup DropDown Buttons

  private func setupDropDowns() {
    kindsDropDown.anchorView = kindSelectButton
    sortDropDown.anchorView = sortSelectButton

    kindsDropDown.dismissMode = .onTap
    sortDropDown.dismissMode = .onTap
    kindsDropDown.direction = .any
    sortDropDown.direction = .any

    setupKindsEachTab()
    sortDropDown.dataSource = createSortStrings()
    setupSortEachTab()
  }

  private func setupKindsEachTab() {

    guard let foodsTableViewController: FoodsTableViewController =  tabControllers![currentIndex] as? FoodsTableViewController
    else {
      fatalError("The tabs controller is not an instance of FoodsTableViewController.")
    }

    let kinds = foodsTableViewController.kinds

    kindSelectButton.setTitle(foodsTableViewController.selectedKind.name, for: .normal)
    kindsDropDown.dataSource = foodsTableViewController.kindDatasource

    // Action triggered on selection
    kindsDropDown.selectionAction = { [weak self] (index, item) in

      if index == 0 {
        foodsTableViewController.extractKindData(kind: foodsTableViewController.kindAll)
      } else {
        let kind = kinds![index - 1]
        foodsTableViewController.extractKindData(kind: kind)
      }
      self?.kindSelectButton.setTitle(item, for: .normal)
    }
  }

  fileprivate func setupSortEachTab() {

    // Action triggered on selection
    guard let foodsTableViewController: FoodsTableViewController =  tabControllers![currentIndex] as? FoodsTableViewController
      else {
        fatalError("The tab controller is not an instance of FoodsTableViewController.")
    }

    sortDropDown.selectionAction = { (index, _) in

      var sortOrder: FoodSortOrder = .nameAsc
      var toastString = String()

      switch index {
      case 0:
        sortOrder = .nameAsc
        toastString.append(NSLocalizedString("Foods.dropdown.sort.nameAsc", comment: ""))
      case 1:
        sortOrder = .nameDsc
        toastString.append(NSLocalizedString("Foods.dropdown.sort.nameDsc", comment: ""))
      case 2:
        sortOrder = .carbohydratePer100gAsc
        toastString.append(NSLocalizedString("Foods.dropdown.sort.carbohydratePer100gAsc", comment: ""))
      case 3:
        sortOrder = .carbohydratePer100gDsc
        toastString.append(NSLocalizedString("Foods.dropdown.sort.carbohydratePer100gDsc", comment: ""))
      case 4:
        sortOrder = .fatPer100gAsc
        toastString.append(NSLocalizedString("Foods.dropdown.sort.fatPer100gAsc", comment: ""))
      case 5:
        sortOrder = .fatPer100gDsc
        toastString.append(NSLocalizedString("Foods.dropdown.sort.fatPer100gDsc", comment: ""))
      default:
        print(sortOrder)
      }

      toastString.append(NSLocalizedString("Foods.dropdown.sort.toast", comment: ""))
      Toast(text: toastString, duration: Delay.long).show()
      foodsTableViewController.sortData(sortOrder: sortOrder)
    }
  }

  func createSortStrings() -> [String] {
    var strings: [String] = [String]()
    strings.append(NSLocalizedString("Foods.dropdown.sort.nameAsc", comment: ""))
    strings.append(NSLocalizedString("Foods.dropdown.sort.nameDsc", comment: ""))
    strings.append(NSLocalizedString("Foods.dropdown.sort.carbohydratePer100gAsc", comment: ""))
    strings.append(NSLocalizedString("Foods.dropdown.sort.carbohydratePer100gDsc", comment: ""))
    strings.append(NSLocalizedString("Foods.dropdown.sort.fatPer100gAsc", comment: ""))
    strings.append(NSLocalizedString("Foods.dropdown.sort.fatPer100gDsc", comment: ""))

    return strings
  }

  // MARK: - PagerTabStripDataSource

  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let types = TypeDataProvider.sharedInstance.findAll()

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    tabControllers = [UIViewController]()

    for type in types {
      guard let vc: FoodsTableViewController =  storyboard.instantiateViewController(withIdentifier: "Foods") as? FoodsTableViewController
        else {
          fatalError("The storyboard controller is not an instance of FoodsTableViewController.")
      }
      vc.setupTabData(indicatorInfo: IndicatorInfo(title: type.name), type: type)
      tabControllers?.append(vc)
    }
    setupDropDowns()

    return tabControllers!
  }

  override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
    super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)

    if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
      // dropdown refresh
      setupKindsEachTab()
      setupSortEachTab()
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
