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
  case fatPer100gAsc
  case fatPer100gDsc

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
    case .fatPer100gAsc:
      return "fat_per100g"
    case .fatPer100gDsc:
      return "fat_per100g"
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
    case .fatPer100gAsc:
      return true
    case .fatPer100gDsc:
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

  func findData(searchText: String) -> [Food] {
    let replacedText = searchText.replacingOccurrences(of: "　", with: " ")
    let texts = replacedText.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")

    var predicateCompounds = [NSCompoundPredicate]()
    for text in (texts.filter { !$0.isEmpty }) {
        let p1 = NSPredicate(format: "name CONTAINS[c] %@", argumentArray: [text])
        let p2 = NSPredicate(format: "search_word CONTAINS[c] %@", argumentArray: [text])
        let p3 = NSPredicate(format: "ANY kinds.name CONTAINS[c] %@", argumentArray: [text])
        let p4 = NSPredicate(format: "ANY kinds.search_word CONTAINS[c] %@", argumentArray: [text])
        predicateCompounds.append(NSCompoundPredicate.init(type: .or, subpredicates: [p1, p2, p3, p4]))
    }
    let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: predicateCompounds)

    let foods = realm.objects(Food.self).filter(predicateCompound)
      .sorted(byKeyPath: FoodSortOrder.nameAsc.key(), ascending: FoodSortOrder.nameAsc.ascending())

    return  Array(foods)
  }
}
