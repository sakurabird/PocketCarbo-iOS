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

class FoodsTableViewController: UITableViewController, IndicatorInfoProvider, FoodTableViewCellDelegate {

  // MARK: Properties

  fileprivate let cellIdentifier = "FoodCell"
  fileprivate var indexPaths: Set<IndexPath> = []

  var indicatorInfo = IndicatorInfo(title: "Kinds")

  var type: Type?
  var kinds: [Kind]?
  var foods: [Food]?

  var kindDatasource = [String]()

  var selectedKind: Kind = Kind()
  var selectedSort: FoodSortOrder = .nameAsc

  let kindAll: Kind = {
    let kind: Kind = Kind()
    kind.id = 0
    kind.name = NSLocalizedString("Foods.dropdown.all", comment: "")
    return kind
  }()


  override func viewDidLoad() {
    super.viewDidLoad()

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
    self.selectedKind = kindAll; // 全ての種類
    self.selectedSort = .nameAsc;

    self.kinds = KindDataProvider.sharedInstance.findData(typeId: type.id!)
    self.foods = FoodDataProvider.sharedInstance.findData(typeId: type.id!, sort: selectedSort)

    // Dropdown Datasource
    kindDatasource.append(kindAll.name!)
    for kind in kinds! {
      kindDatasource.append(kind.name!)
    }
}

  private func setupTableView() {
    tableView.backgroundColor = UIColor(patternImage: UIImage(named: "main_bg")!)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200.0
  }

  // MARK: - IndicatorInfoProvider

  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return indicatorInfo
  }

  // MARK: - TableView

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    let foodCell = cell as! FoodTableViewCell

    foodCell.delegate = self
    if cellIsExpanded(at: indexPath) {
      foodCell.cellState = .collapsed
      removeExpandedIndexPath(indexPath)
    } else {
      foodCell.cellState = .expanded
      addExpandedIndexPath(indexPath)
    }

    tableView.beginUpdates()
    tableView.endUpdates()
  }

  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    // 時々セルの取得に失敗することがある
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    let foodCell = cell as! FoodTableViewCell

    foodCell.cellState = .collapsed
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
    kinds = KindDataProvider.sharedInstance.findData(typeId: (type?.id)!)
    foods = FoodDataProvider.sharedInstance.findData(typeId: (type?.id)!, sort: selectedSort)
    tableView.reloadData()
  }

  func extractKindData(kind: Kind) {
    self.selectedKind = kind;
    refeshData()
  }

  func sortData(sortOrder: FoodSortOrder) {
    self.selectedSort = sortOrder;
    refeshData()
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

  private func refeshData() {
    if selectedKind.id == 0 {
      foods = FoodDataProvider.sharedInstance.findData(typeId: (type?.id)!, sort: selectedSort)
    } else {
      foods = FoodDataProvider.sharedInstance.findData(typeId: (type?.id)!, kindId: selectedKind.id, sort: selectedSort)
    }

    tableView.reloadData()
    let indexPath = NSIndexPath(row: 0, section: 0)
    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
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

