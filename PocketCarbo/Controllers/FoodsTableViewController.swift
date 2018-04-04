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

  let searchController = UISearchController(searchResultsController: nil)

  let kindAll: Kind = {
    let kind: Kind = Kind()
    kind.id = 0
    kind.name = NSLocalizedString("Foods.dropdown.all", comment: "")
    return kind
  }()

  // MARK: - View life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
    setupSearchController()

    // Observe Food,Kind DB update event
    NotificationCenter.default.observeEvent(observer: self,
                                            selector: #selector(FoodsTableViewController.dataUpdated),
                                            notification: NotificationEvent.foodsAndKindsUpdated)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if #available(iOS 11.0, *) {
      // 検索画面の検索欄を常に表示しておく
      navigationItem.hidesSearchBarWhenScrolling = false
    }
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

  func setupTableView() {
    tableView.backgroundColor = UIColor(patternImage: UIImage(named: "main_bg")!)
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    self.tableView.contentInset = insets
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
    refeshData()
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

// -----------------------
// MARK: - 検索画面用のextension
// -----------------------
extension FoodsTableViewController: UISearchBarDelegate {

  // MARK: - Setup

  fileprivate func setupSearchController() {
    // Setup the Search Controller
    definesPresentationContext = true
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false

    searchController.searchBar.placeholder = NSLocalizedString("Foods.search.placeholder", comment: "")
    searchController.searchBar.tintColor = .white // cancel text
    if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
      if let backgroundview = textfield.subviews.first {
        backgroundview.backgroundColor = UIColor.white // Background color
        // Rounded corner
        backgroundview.layer.cornerRadius = 10;
        backgroundview.clipsToBounds = true;
      }
    }

    if #available(iOS 11.0, *) {
      navigationItem.searchController = searchController
    } else {
      // Fallback on earlier versions
    }
  }

  func setupAllData() {
    setLeftNavigationBarBack()
    self.selectedKind = kindAll;
    self.foods = FoodDataProvider.sharedInstance.findAll()
  }

  // MARK: - UISearchBar Delegate

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filterContentForSearchText(searchBar.text!)
  }

  // MARK: - Helper

  func isFiltering() -> Bool {
    return searchController.isActive && !searchBarIsEmpty()
  }

  func searchBarIsEmpty() -> Bool {
    // Returns true if the text is empty or nil
    return searchController.searchBar.text?.isEmpty ?? true
  }

  func filterContentForSearchText(_ searchText: String) {

    if searchBarIsEmpty() {
      guard let foodsCount: Int = foods?.count else {
        return
      }
      if (foodsCount > 0) {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
      }
      self.foods = FoodDataProvider.sharedInstance.findAll()
    } else {
      self.foods = FoodDataProvider.sharedInstance.findData(searchText: searchText)
    }

    clearExpandedIndexPath()
    tableView.reloadData()
  }
}

extension FoodsTableViewController: UISearchResultsUpdating {

  // MARK: - UISearchResultsUpdating Delegate

  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}

// ---------------------------------
// MARK: - お気に入り画面用のextension
// ---------------------------------
extension FoodsTableViewController {

  // MARK: - Setup

  func setupFavoritesData() {
    self.selectedKind = kindAll;
    self.foods = FavoriteDataProvider.sharedInstance.findAll()

    clearExpandedIndexPath()
    tableView.reloadData()
  }
}
