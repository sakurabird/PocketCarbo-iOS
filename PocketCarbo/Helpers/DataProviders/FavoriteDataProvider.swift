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

  let realm = Realm.safeInit()

  func findAll() -> [Food] {
    let favorites = realm!.objects(FavoriteFood.self).sorted(byKeyPath: "createdAt", ascending: false)
    var foods: [Food] = [Food]()

    for fav in favorites {
      foods.append(fav.food!)
    }
    return foods
  }

  func isFavorite(food: Food) -> Bool {
    let predicate = NSPredicate(format: "id == %i", food.id)
    if realm!.objects(FavoriteFood.self).filter(predicate).first != nil {
      return true
    }
    return false
  }

  func saveData(food: Food) {
    let fav = FavoriteFood()
    fav.id = food.id
    fav.food = food
    fav.createdAt = Date()

    realm!.safeWrite {
      realm!.add(fav, update: .all)
      NotificationCenter.default.postEvent(notification: NotificationEvent.favoritesUpdated, object: self, userInfo: nil)
    }
  }

  func removeData(food: Food) {
    let predicate = NSPredicate(format: "id == %i", food.id)
    let favoriteFood = realm!.objects(FavoriteFood.self).filter(predicate)

    realm!.safeWrite {
      realm!.delete(favoriteFood)
      NotificationCenter.default.postEvent(notification: NotificationEvent.favoritesUpdated, object: self, userInfo: nil)
    }
  }
}
