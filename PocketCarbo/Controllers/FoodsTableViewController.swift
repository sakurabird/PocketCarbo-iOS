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

  var isFavotitesScene = false
  var isSearchScene = false

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

  fileprivate var canHideOrShowNavBar = false
  fileprivate var lastContentOffset: CGFloat = 0

  // MARK: - View life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()

    // Observe Food,Kind DB update event
    NotificationCenter.default.observeEvent(observer: self,
                                            selector: #selector(FoodsTableViewController.dataUpdated),
                                            notification: NotificationEvent.foodsAndKindsUpdated)

    // Observe favorites DB update event
    NotificationCenter.default.observeEvent(observer: self,
                                            selector: #selector(FoodsTableViewController.favoritesUpdated),
                                            notification: NotificationEvent.favoritesUpdated)
  }

  // MARK: - deinit

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: - Setup

  func setupTabData(indicatorInfo: IndicatorInfo, type: Type) {
    self.indicatorInfo = indicatorInfo
    self.type = type
    self.selectedKind = kindAll // 全ての種類
    self.selectedSort = .nameAsc

    self.kinds = KindDataProvider.sharedInstance.findData(typeId: type.id!)
    self.foods = FoodDataProvider.sharedInstance.findData(typeId: type.id!, sort: selectedSort)

    // Dropdown Datasource
    kindDatasource.append(kindAll.name!)
    for kind in kinds! {
      kindDatasource.append(kind.name!)
    }
}

  func setupTableView() {
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    self.tableView.contentInset = insets
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100.0
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
    guard let foodCell: FoodTableViewCell = cell as? FoodTableViewCell
      else {
        fatalError("The cell is not an instance of FoodTableViewCell.")
    }

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
    guard let foodCell: FoodTableViewCell = cell as? FoodTableViewCell
      else {
        fatalError("The cell is not an instance of FoodTableViewCell.")
    }

    foodCell.cellState = .collapsed
    removeExpandedIndexPath(indexPath)

    tableView.beginUpdates()
    tableView.endUpdates()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let foods = self.foods else {
      self.tableView.setEmptyView()
      return 0
    }

    if foods.count  == 0 {
      self.tableView.setEmptyView()
    } else {
      self.tableView.restore()
    }
    return foods.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: FoodTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? FoodTableViewCell
      else {
        fatalError("The cell is not an instance of FoodTableViewCell.")
    }

    cell.update(food: foods![indexPath.row])

    cell.cellState = cellIsExpanded(at: indexPath) ? .expanded : .collapsed

    return cell
  }

  // MARK: Functions

  @objc func dataUpdated(notification: NSNotification) {
    refeshData()
  }

  @objc func favoritesUpdated(notification: NSNotification) {
    if !isFavotitesScene && !isSearchScene {
      refeshData()
    }
  }

  func extractKindData(kind: Kind) {
    self.selectedKind = kind
    refeshData()
  }

  func sortData(sortOrder: FoodSortOrder) {
    self.selectedSort = sortOrder
    refeshData()
  }

  // MARK: - Private functions

  private func cellIsExpanded(at indexPath: IndexPath) -> Bool {
    return self.indexPaths.contains(indexPath)
  }

  private func addExpandedIndexPath(_ indexPath: IndexPath) {
    self.indexPaths.insert(indexPath)
  }

  private func removeExpandedIndexPath(_ indexPath: IndexPath) {
    self.indexPaths.remove(indexPath)
  }

  fileprivate func clearExpandedIndexPath() {
    self.indexPaths.removeAll()
  }

  private func refeshData() {
    if selectedKind.id == 0 {
      foods = FoodDataProvider.sharedInstance.findData(typeId: (type?.id)!, sort: selectedSort)
    } else {
      foods = FoodDataProvider.sharedInstance.findData(typeId: (type?.id)!, kindId: selectedKind.id, sort: selectedSort)
    }

    clearExpandedIndexPath()
    tableView.reloadData()
    let indexPath = NSIndexPath(row: 0, section: 0)
    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
  }

  // MARK: - FoodTableViewCell Actions

  func didTapShare(_ sender: FoodTableViewCell, shareText: String) {

    let activityViewController: UIActivityViewController = UIActivityViewController(
      activityItems: [shareText], applicationActivities: nil)

    // This lines is for the popover you need to show in iPad
    activityViewController.popoverPresentationController?.sourceView = sender

    // This line remove the arrow of the popover to show in iPad
    activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
    activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)

    // Anything you want to exclude
    activityViewController.excludedActivityTypes = [
      UIActivity.ActivityType.assignToContact,
      UIActivity.ActivityType.saveToCameraRoll,
      UIActivity.ActivityType.addToReadingList
    ]

    self.present(activityViewController, animated: true, completion: nil)
  }
}

// -------------------------------------------
// MARK: - お気に入り画面・検索画面用のextension
// -------------------------------------------
extension FoodsTableViewController {

  // お気に入り画面用のsetup
  func setupFavoritesData() {
    self.isFavotitesScene = true
    self.selectedKind = kindAll
    self.foods = FavoriteDataProvider.sharedInstance.findAll()

    clearExpandedIndexPath()
    tableView.reloadData()
  }

  // 検索画面用のsetup
  func setupAllData() {
    self.isSearchScene = true
    self.selectedKind = kindAll
    self.foods = FoodDataProvider.sharedInstance.findAll()
  }

  func didChangeSearchText(_ searchText: String) {
    // 検索フィールドが変更された
    if searchText.isEmpty {
      guard let foodsCount: Int = self.foods?.count else {
        return
      }
      if foodsCount > 0 {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
      }
      // emptyの場合は全件表示
      self.foods = FoodDataProvider.sharedInstance.findAll()
    } else {
      self.foods = FoodDataProvider.sharedInstance.findData(searchText: searchText)
    }

    clearExpandedIndexPath()
    tableView.reloadData()
  }
}

extension FoodsTableViewController {

  // MARK: - UIScrollView Delegate

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if lastContentOffset > scrollView.contentOffset.y && canHideOrShowNavBar {
      if parent?.navigationController?.isNavigationBarHidden ?? false {
        parent?.navigationController?.setNavigationBarHidden(false, animated: true)
      }
    } else if lastContentOffset < scrollView.contentOffset.y && canHideOrShowNavBar {
      if !(parent?.navigationController?.isNavigationBarHidden ?? false) {
        parent?.navigationController?.setNavigationBarHidden(true, animated: true)
      }
    }
    lastContentOffset = scrollView.contentOffset.y
  }

  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    canHideOrShowNavBar = true
  }

  override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    canHideOrShowNavBar = false
  }

  override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    if parent?.navigationController?.isNavigationBarHidden != nil {
      parent?.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    return true
  }

}
