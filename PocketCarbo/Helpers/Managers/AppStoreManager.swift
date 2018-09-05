//
//  AppStoreManager.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/09/06.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation
import StoreKit

final class AppdStoreManager {

  private init() { }
  static let sharedInstance = AppdStoreManager()

  // 15回起動後フィードバックを促す
  static let REVIEW_LAUNCH_COUNT = 15

  func showReviewDialog() {

    let launchCount = UserDefaults.standard.getLaunchCount()
    if  launchCount >= AppdStoreManager.REVIEW_LAUNCH_COUNT {
        SKStoreReviewController.requestReview()
    }
  }
}
