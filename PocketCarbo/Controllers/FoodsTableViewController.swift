//
//  FoodTableViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip
import DropDown

class FoodsTableViewController: UITableViewController, IndicatorInfoProvider, FoodTableViewCellDelegate {

  // MARK: Properties

  fileprivate let cellIdentifier = "FoodCell"
  fileprivate var indexPaths: Set<IndexPath> = []

  var indicatorInfo = IndicatorInfo(title: "Kinds")

  var type: Type?
  var kind: [Kind]?
  var foods: [Food]?

  var sort: FoodSortOrder = .nameAsc

  let kindsDropDown = DropDown()
  let sortDropDown = DropDown()


  @IBOutlet weak var kindSelectButton: UIButton!
  @IBOutlet weak var sortSelectButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupDropDowns()
    setupTableView()

    // Observe Food,Kind DB update event
    NotificationCenter.default.observeEvent(observer: self,
                                            selector: #selector(FoodsTableViewController.dataUpdated),
                                            notification: NotificationEvent.foodsAndKindsUpdated)
  }

  // MARK: - deinit

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  //MARK: - Setup

  func setupTabData(indicatorInfo: IndicatorInfo, type: Type) {
    self.indicatorInfo = indicatorInfo
    self.type = type
    self.kind = KindDataProvider.sharedInstance.findData(typeId: type.id!)
    self.foods = FoodDataProvider.sharedInstance.findData(typeId: type.id!, sort: sort)
  }

  private func setupTableView() {
    tableView.backgroundColor = UIColor(patternImage: UIImage(named: "main_bg")!)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200.0
  }

  private func setupDropDowns() {
    // The view to which the drop down will appear on
    kindsDropDown.anchorView = kindSelectButton // UIView or UIBarButtonItem
    sortDropDown.anchorView = sortSelectButton // UIView or UIBarButtonItem

    kindsDropDown.dismissMode = .onTap
    sortDropDown.dismissMode = .onTap
    kindsDropDown.direction = .any
    sortDropDown.direction = .any

    // TODO : ちゃんと実装

    // The list of items to display. Can be changed dynamically
    kindsDropDown.dataSource = ["Car", "Motorcycle", "Truck"]
    // Action triggered on selection
    kindsDropDown.selectionAction = { [weak self] (index, item) in
      self?.kindSelectButton.setTitle(item, for: .normal)
    }
    sortDropDown.dataSource = ["Car", "Motorcycle", "Truck","あああ"]
    // Action triggered on selection
    sortDropDown.selectionAction = { [weak self] (index, item) in
      self?.sortSelectButton.setTitle(item, for: .normal)
    }
  }

  // MARK: - IndicatorInfoProvider

  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return indicatorInfo
  }

  // MARK: - Actions

  @IBAction func didTapKindSelect(_ sender: UIButton) {
    kindsDropDown.show()
  }

  @IBAction func didTapSort(_ sender: Any) {
    sortDropDown.show()
  }

  // MARK: - TableView

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! FoodTableViewCell

    cell.delegate = self
    if cellIsExpanded(at: indexPath) {
      cell.cellState = .collapsed
      removeExpandedIndexPath(indexPath)
    } else {
      cell.cellState = .expanded
      addExpandedIndexPath(indexPath)
    }

    tableView.beginUpdates()
    tableView.endUpdates()
  }

  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! FoodTableViewCell

    cell.cellState = .collapsed
    removeExpandedIndexPath(indexPath)

    tableView.beginUpdates()
    tableView.endUpdates()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let foods = self.foods else {
      return 0
    }
    return foods.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! FoodTableViewCell

    cell.update(food: foods![indexPath.row])

    cell.cellState = cellIsExpanded(at: indexPath) ? .expanded : .collapsed

    return cell
  }

  // MARK: Functions

  @objc func dataUpdated(notification: NSNotification) {
    kind = KindDataProvider.sharedInstance.findData(typeId: (type?.id)!)
    foods = FoodDataProvider.sharedInstance.findData(typeId: (type?.id)!, sort: sort)
    tableView.reloadData()
  }

  // MARK: - Private functions

  private func cellIsExpanded(at indexPath: IndexPath) -> Bool {
    return indexPaths.contains(indexPath)
  }

  private func addExpandedIndexPath(_ indexPath: IndexPath) {
    indexPaths.insert(indexPath)
  }

  private func removeExpandedIndexPath(_ indexPath: IndexPath) {
    indexPaths.remove(indexPath)
  }

  // MARK: - FoodTableViewCell Actions

  func didTapFavorites(_ sender: FoodTableViewCell) {
  }

  func didTapShare(_ sender: FoodTableViewCell, shareText: String) {
    let shareUrl = NSURL(string: NSLocalizedString("appURL", comment: ""))!

    let activityViewController : UIActivityViewController = UIActivityViewController(
      activityItems: [shareText, shareUrl], applicationActivities: nil)

    // This lines is for the popover you need to show in iPad
    activityViewController.popoverPresentationController?.sourceView = sender

    // This line remove the arrow of the popover to show in iPad
    activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
    activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)

    // Anything you want to exclude
    activityViewController.excludedActivityTypes = [
      UIActivityType.assignToContact,
      UIActivityType.saveToCameraRoll,
      UIActivityType.addToReadingList,
    ]

    self.present(activityViewController, animated: true, completion: nil)

  }

}

