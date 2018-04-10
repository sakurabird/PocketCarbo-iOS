//
//  FavoritesViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class FavoritesViewController: UIViewController {

  // MARK: Properties

  var foodsTableViewController: FoodsTableViewController?
  var notificationToken: NotificationToken?

  @IBOutlet weak var adBannerView: GADBannerView!
  
  // MARK: - View life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupAdMob()
    setupFavorites()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNavigationBarItem()
    self.navigationController?.hidesBarsOnSwipe = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    notificationToken?.invalidate()
  }

  // MARK: Functions

  func updateFavorites() {
    if self.foodsTableViewController == nil {
      return
    }
    self.foodsTableViewController?.setupFavoritesData()
  }

  // MARK: Private Functions

  private func setupFavorites() {
    guard let vc = self.childViewControllers.first as? FoodsTableViewController else  {
      fatalError("Check storyboard for missing FoodsTableViewController")
    }
    self.foodsTableViewController = vc
    updateFavorites()

    let realm = try! Realm()
    notificationToken = realm.observe { [unowned self] note, realm in
      self.updateFavorites()
    }
  }

  private func setupAdMob() {
    adBannerView.adUnitID = ADManager.sharedInstance.getBannerId()
    adBannerView.rootViewController = self
    adBannerView.load(ADManager.sharedInstance.getGADRequest())
  }
}
