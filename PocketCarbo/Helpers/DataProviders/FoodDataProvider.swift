//
//  FoodDataProvider.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation
import Realm
import RealmSwift


enum FoodSortOrder: Int {
  case nameAsc = 0
  case nameDsc
  case carbohydratePer100gAsc
  case carbohydratePer100gDsc

  func key() -> String {
    switch self {
    case .nameAsc:
      return "name"
    case .nameDsc:
      return "name"
    case .carbohydratePer100gAsc:
      return "carbohydrate_per_100g"
    case .carbohydratePer100gDsc:
      return "carbohydrate_per_100g"
    }
  }

  func ascending() -> Bool {
    switch self {
    case .nameAsc:
      return true
    case .nameDsc:
      return false
    case .carbohydratePer100gAsc:
      return true
    case .carbohydratePer100gDsc:
      return false
    }
  }
}

final class FoodDataProvider {

  private init() { }
  static let sharedInstance = FoodDataProvider()

  let realm: Realm = try! Realm()

  func findAll() -> [Food] {
    let foods = realm.objects(Food.self).sorted(byKeyPath: FoodSortOrder.nameAsc.key())
    return Array(foods)
  }

  func findData(typeId: Int, sort: FoodSortOrder) -> [Food] {

    let predicate = NSPredicate(format: "type_id == %i", typeId)
    let foods = realm.objects(Food.self).filter(predicate)
      .sorted(byKeyPath: sort.key(), ascending: sort.ascending())

    return  Array(foods)
  }

  func findData(typeId: Int, kindId: Int, sort: FoodSortOrder) -> [Food] {

    let predicate = NSPredicate(format: "type_id == %i AND kind_id == %i", argumentArray: [typeId, kindId])
    let foods = realm.objects(Food.self).filter(predicate).sorted(byKeyPath: sort.key(), ascending: sort.ascending())
    
    return  Array(foods)
  }
}
