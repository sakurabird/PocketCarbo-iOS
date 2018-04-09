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
    case showTutorialKey
    case isTutorialShowingKey
    case dataVersionKey
  }

  func isFirstLaunch() -> Bool {
    register(defaults: [UserDefaultsKeys.isFirstLaunchKey.rawValue : true])
    return bool(forKey: UserDefaultsKeys.isFirstLaunchKey.rawValue)
  }

  func setFirstLaunch(firstLaunch: Bool) {
    set(firstLaunch, forKey: UserDefaultsKeys.isFirstLaunchKey.rawValue)
    synchronize()
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
}
