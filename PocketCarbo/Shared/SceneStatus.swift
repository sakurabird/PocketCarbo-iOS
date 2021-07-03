//
//  SceneStatus.swift
//  PocketCarbo
//
//  Created by Sakura on 2020/03/20.
//  Copyright © 2020 Sakura. All rights reserved.
//

import Foundation

final class SceneStatus {
  private init() { }
  static let sharedInstance = SceneStatus()

  enum SceneActiveStatus {
    case Active
    case InActive
  }

  var currentFavoritesStatus = SceneActiveStatus.InActive
  var currentSearchStatus = SceneActiveStatus.InActive
}
