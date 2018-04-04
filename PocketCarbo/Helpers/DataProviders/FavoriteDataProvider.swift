//
//  FavoriteDataProvider.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/04/02.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class FavoriteDataProvider {

  private init() { }
  static let sharedInstance = FavoriteDataProvider()

  let realm: Realm = try! Realm()

  func findAll() -> [FavoriteFood] {
    let favorite = realm.objects(FavoriteFood.self).sorted(byKeyPath: "createdAt", ascending: false)
//    print(realm.objects(FavoriteFood.self))
    return Array(favorite)
  }

  func isFavorite(food: Food) -> Bool {

    print(realm.objects(FavoriteFood.self))
    let predicate = NSPredicate(format: "id == %i", food.id)
    if realm.objects(FavoriteFood.self).filter(predicate).first != nil {
      return true
    }
    return false
  }

  func saveData(food: Food) {
    let fav = FavoriteFood()
    fav.id = food.id
    fav.food = food
    fav.createdAt = Date()

    try! realm.write {
      realm.add(fav, update: true)
    }
  }

  func removeData(food: Food) {
    let predicate = NSPredicate(format: "id == %i", food.id)
    let favoriteFood = realm.objects(FavoriteFood.self).filter(predicate)

    try! realm.write {
      realm.delete(favoriteFood)
    }
  }
}
