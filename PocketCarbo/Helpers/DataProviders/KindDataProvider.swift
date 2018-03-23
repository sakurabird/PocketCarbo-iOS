//
//  KindDataProvider.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class KindDataProvider {

  private init() { }
  static let sharedInstance = KindDataProvider()

  let realm: Realm = try! Realm()

  func findData(typeId: Int) -> [Kind] {

    let predicate = NSPredicate(format: "type_id == %i", typeId)
    let kinds = realm.objects(Kind.self).filter(predicate).sorted(byKeyPath: "id")
    
    return  Array(kinds)
  }
}
