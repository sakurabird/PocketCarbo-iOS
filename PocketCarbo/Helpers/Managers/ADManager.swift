//
//  ADManager.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/04/10.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation
import GoogleMobileAds

final class ADManager {

  private init() { }
  static let sharedInstance = ADManager()

  func setupAdMob() {
    if let path = Bundle.main.path(forResource: "Secret", ofType: "plist") {
      let dictRoot = NSDictionary(contentsOfFile: path)
      if let dict = dictRoot {
        let id = dict["AD_MOB_APP_ID"] as! String
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.configure(withApplicationID: id)
      }
    }
  }

  func getBannerId() -> String {
    var id: String = "ca-app-pub-3940256099942544/2934735716" // for Test

    #if DEBUG
      #else
      if let path = Bundle.main.path(forResource: "Secret", ofType: "plist") {
        let dictRoot = NSDictionary(contentsOfFile: path)
        if let dict = dictRoot {
          id = dict["AD_MOB_BANNER_ID"] as! String
        }
      }
    #endif
    print("ad:\(id)")
    return id
  }

  func getGADRequest() -> GADRequest {
    let request = GADRequest()
    // TODO : テスト用のデバイスを追加したらここにdevice idを追加する
    request.testDevices = [ "1272c87f3c314b9131df2f16c82e646f" ] // iPhone7
    return request
  }
}
