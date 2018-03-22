//
//  FavoriteFood.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/22.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteFood : RealmSwift.Object {
  @objc dynamic var id: Int = 0
  @objc dynamic var food: Food?
  @objc dynamic var createdAt: Date?

  override static func primaryKey() -> String? {
    return "id"
  }
}
