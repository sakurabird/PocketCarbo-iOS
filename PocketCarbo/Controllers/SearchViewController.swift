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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.searchController.isActive = true // for focus input field
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
    searchController.delegate = self // for focus input field
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false

    searchController.searchBar.placeholder = NSLocalizedString("Foods.search.placeholder", comment: "")
    searchController.searchBar.tintColor = .white // cancel text

    if #available(iOS 13.0, *) {
      searchController.searchBar.searchTextField.textColor = UIColor(named: "ColorGray800")! // input text color
      searchController.searchBar.searchTextField.tintColor = UIColor(named: "ColorGray600")! // input field cursor color
      searchController.searchBar.searchTextField.backgroundColor = .white // Background color
      searchController.searchBar.searchTextField.leftView?.tintColor = UIColor(named: "ColorGray600")! // search icon color
    } else {
      if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField,
         let iconView = textfield.leftView as? UIImageView {

        textfield.tintColor = UIColor(named: "ColorGray600")! // input field cursor color
        textfield.textColor = UIColor(named: "ColorGray800")!

        if let backgroundview = textfield.subviews.first {
          backgroundview.backgroundColor = UIColor.white // Background color
          // Rounded corner
          backgroundview.layer.cornerRadius = 10
          backgroundview.clipsToBounds = true

          iconView.image = iconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
          iconView.tintColor = UIColor(named: "ColorGray600")! // search icon color
        }
      }
    }

    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "ColorGray800")!] // input text color

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

extension SearchViewController: UISearchControllerDelegate {
  func didPresentSearchController(_ searchController: UISearchController) {
    DispatchQueue.global(qos: .background).async {
      DispatchQueue.main.async {
        // focus input field メインスレッド上でしないとキーボードが出ない
        searchController.searchBar.becomeFirstResponder()
      }
    }
  }
}
