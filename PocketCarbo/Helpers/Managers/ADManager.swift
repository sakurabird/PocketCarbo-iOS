//
//  ADManager.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/04/10.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

final class ADManager {

  private init() { }
  static let sharedInstance = ADManager()

  // click interval time
  static let CLICK_DELAY_SECONDS: Double = 60 * 60; // 60 min

  func setupAdMob() {
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    // TODO : テスト用のデバイスを追加したらここにdevice idを追加する
    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
      [ "1272c87f3c314b9131df2f16c82e646f", // iPhone7
        "af3e50d387305470fea76ab1cf6b9e84" ] // iPod touch gen7
  }

  func showATTAuthorizationAlart() {
    if #available(iOS 14, *) {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
        // Tracking authorization completed. Start loading ads here.
        // loadAd()
      })
    }
  }

  func getBannerId() -> String {
    var bannerId: String = "ca-app-pub-3940256099942544/2934735716" // for Test

    #if DEBUG
    #else
    if let path = Bundle.main.path(forResource: "Secret", ofType: "plist") {
      let dictRoot = NSDictionary(contentsOfFile: path)
      if let dict = dictRoot {
        guard let id: String = dict["AD_MOB_BANNER_ID"] as? String
        else {
          fatalError("AD_MOB_BANNER_ID could not instantiated.")
        }
        bannerId = id
      }
    }
    #endif
    return bannerId
  }

  func isIntervalOK() -> Bool {
    let now = Date()
    let lastClickDate = UserDefaults.standard.getlastADClickDate()
    let lastClickDateWithInterval = lastClickDate.addingTimeInterval(TimeInterval(ADManager.CLICK_DELAY_SECONDS))
    if now > lastClickDateWithInterval {
      return true
    }
    return false
  }

  func culculateIntervalTimeSeconds(now: Date) -> Double {
    let lastClickDate = UserDefaults.standard.getlastADClickDate()
    var intervalTimeSeconds = ADManager.CLICK_DELAY_SECONDS
    let passedTimeSeconds = now.timeIntervalSince1970 - lastClickDate.timeIntervalSince1970
    intervalTimeSeconds = ADManager.CLICK_DELAY_SECONDS - passedTimeSeconds
    if intervalTimeSeconds > ADManager.CLICK_DELAY_SECONDS {
      intervalTimeSeconds = ADManager.CLICK_DELAY_SECONDS
    }
    return intervalTimeSeconds
  }
}
