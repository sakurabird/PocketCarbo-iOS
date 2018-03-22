//
//  UserDefault+helpers.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/22.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation

extension UserDefaults {

  enum UserDefaultsKeys: String {
    case dataVersionKey
  }

  func setDataVersion(dataVersion: Int) {
    set(dataVersion, forKey: UserDefaultsKeys.dataVersionKey.rawValue)
    synchronize()
  }

  func getDataVersion() -> Int {
    return integer(forKey: UserDefaultsKeys.dataVersionKey.rawValue)
  }
}
