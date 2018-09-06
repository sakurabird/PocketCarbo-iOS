//
//  AdBannerViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/09/07.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdBannerViewController: UIViewController {

  @IBOutlet weak var adBannerView: GADBannerView!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupAdMob()
  }


  private func setupAdMob() {
    adBannerView.adUnitID = ADManager.sharedInstance.getBannerId()
    adBannerView.rootViewController = self
    adBannerView.load(ADManager.sharedInstance.getGADRequest())
  }
}

