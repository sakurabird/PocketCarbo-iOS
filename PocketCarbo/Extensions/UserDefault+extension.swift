//
//  UserDefault+extention.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/22.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation

extension UserDefaults {

  enum UserDefaultsKeys: String {
    case isFirstLaunchKey
    case launchCountKey
    case showTutorialKey
    case isTutorialShowingKey
    case dataVersionKey
    case appMessageNoKey
    case lastADClickDateKey
  }

  func isFirstLaunch() -> Bool {
    register(defaults: [UserDefaultsKeys.isFirstLaunchKey.rawValue : true])
    return bool(forKey: UserDefaultsKeys.isFirstLaunchKey.rawValue)
  }

  func setFirstLaunch(firstLaunch: Bool) {
    set(firstLaunch, forKey: UserDefaultsKeys.isFirstLaunchKey.rawValue)
    synchronize()
  }

  func incrementLaunchCount() {
    let launchCount = getLaunchCount()
    set((launchCount + 1), forKey: UserDefaultsKeys.launchCountKey.rawValue)
    synchronize()
  }

  func getLaunchCount() -> Int {
    register(defaults: [UserDefaultsKeys.launchCountKey.rawValue : 0])
    return integer(forKey: UserDefaultsKeys.launchCountKey.rawValue)
  }

  func isShowTutorial() -> Bool {
    register(defaults: [UserDefaultsKeys.showTutorialKey.rawValue : true])
    return bool(forKey: UserDefaultsKeys.showTutorialKey.rawValue)
  }

  func setShowTutorial(showTutorial: Bool) {
    set(showTutorial, forKey: UserDefaultsKeys.showTutorialKey.rawValue)
    synchronize()
  }

  func isTutorialShowing() -> Bool {
    register(defaults: [UserDefaultsKeys.isTutorialShowingKey.rawValue : false])
    return bool(forKey: UserDefaultsKeys.isTutorialShowingKey.rawValue)
  }

  func setTutorialShowing(tutorialShowing: Bool) {
    set(tutorialShowing, forKey: UserDefaultsKeys.isTutorialShowingKey.rawValue)
    synchronize()
  }

  func setDataVersion(dataVersion: Int) {
    set(dataVersion, forKey: UserDefaultsKeys.dataVersionKey.rawValue)
    synchronize()
  }

  func getDataVersion() -> Int {
    return integer(forKey: UserDefaultsKeys.dataVersionKey.rawValue)
  }

  func getAppMessageNo() -> Int {
    register(defaults: [UserDefaultsKeys.appMessageNoKey.rawValue : 0])
    return integer(forKey: UserDefaultsKeys.appMessageNoKey.rawValue)
  }

  func setAppMessageNo(appMessageNo: Int) {
    set(appMessageNo, forKey: UserDefaultsKeys.appMessageNoKey.rawValue)
    synchronize()
  }

  func getlastADClickDate() -> Date {
    if let date = object(forKey: UserDefaultsKeys.lastADClickDateKey.rawValue) as? Date {
      return date
    }
    // 存在しない場合所定の時間経過前の日付を返す
    let now = Date()
    let date2 = Date(timeInterval: TimeInterval(ADManager.CLICK_DELAY_SECONDS * -100), since: now)
    return date2
  }

  func setlastADClickDate(lastADClickDate: Date) {
    set(lastADClickDate, forKey: UserDefaultsKeys.lastADClickDateKey.rawValue)
    synchronize()
  }
}
