//
//  SearchViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/04/10.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

  let searchController = UISearchController(searchResultsController: nil)
  var foodsTableViewController: FoodsTableViewController?

  // MARK: - View life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupFoods()
    setupSearchController()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SceneStatus.sharedInstance.currentSearchStatus = .Active

    self.setLeftNavigationBarBack()
    self.navigationController?.hidesBarsOnSwipe = true
    // 検索画面の検索欄を常に表示しておく
    self.navigationItem.hidesSearchBarWhenScrolling = false
  }

  override func viewWillDisappear(_ animated: Bool) {
    SceneStatus.sharedInstance.currentSearchStatus = .InActive
  }

  // MARK: Private Functions

  private func setupFoods() {
    guard let vc = self.children.first as? FoodsTableViewController else {
      fatalError("Check storyboard for missing FoodsTableViewController")
    }
    self.navigationItem.title = NSLocalizedString("search", comment: "")
    self.foodsTableViewController = vc
    foodsTableViewController?.setupAllData()
  }

  private func setupSearchController() {
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
        backgroundview.layer.cornerRadius = 10
        backgroundview.clipsToBounds = true
      }
    }
    if #available(iOS 13.0, *) {
      searchController.searchBar.searchTextField.backgroundColor = UIColor.white
    }
    navigationItem.searchController = searchController
  }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filterContentForSearchText(searchBar.text!)
  }

  // MARK: - Helper

  func searchBarIsEmpty() -> Bool {
    // Returns true if the text is empty or nil
    return searchController.searchBar.text?.isEmpty ?? true
  }

  func filterContentForSearchText(_ searchText: String) {
    if searchBarIsEmpty() || searchText.isEmpty {
      foodsTableViewController?.didChangeSearchText("")
      return
    }
    foodsTableViewController?.didChangeSearchText(searchText)
  }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {

  // MARK: - UISearchResultsUpdating Delegate

  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}
