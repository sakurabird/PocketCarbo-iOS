//
//  AppLaunchManager.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/22.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class AppLaunchManager {

  private init() { }
  static let sharedInstance = AppLaunchManager()

  var foodsAndKinds: FoodsAndKinds?

  func onAppStarted() {

    // Lanch Count
    UserDefaults.standard.incrementLaunchCount()

    setupRealm()

    if !newDataVersion() {
      return
    }

    loadJsonFile()
  }

  // MARK: Private Methods

  private func setupRealm() {
    let config = Realm.Configuration(
      schemaVersion: 3,

      migrationBlock: { migration, oldSchemaVersion in

        if oldSchemaVersion < 1 {
          // Kindにsearch_wordを追加 & Foodにnotesを追加
          migration.enumerateObjects(ofType: Kind.className()) { _, newObject in
            newObject!["search_word"] = ""
          }
          migration.enumerateObjects(ofType: Food.className()) { _, newObject in
            newObject!["notes"] = ""
          }
        }

        // if oldSchemaVersion < 2 {
          // Kindにfoods: List<Food>, Foodsにkinds・: LinkingObjects<Kind>を追加
        // }

        // if oldSchemaVersion < 3 {
          // Foodにfat_per100gを追加
        // }
    })

    Realm.Configuration.defaultConfiguration = config
  }

  private func newDataVersion() -> Bool {
    if UserDefaults.standard.getDataVersion() == Config.dataVersion {
      return false
    }
    return true
  }

  private func loadJsonFile() {
    guard let path = Bundle.main.path(forResource: "foods_and_kinds", ofType: "json") else { return }
    let url = URL(fileURLWithPath: path)

    do {
      let data = try Data(contentsOf: url)
      try
        foodsAndKinds = JSONDecoder().decode(FoodsAndKinds.self, from: data)
        saveDB()
    } catch {
      print(error)
    }
  }

  private func saveDB() {
    guard let kinds = self.foodsAndKinds?.kinds else { return }
    guard let foods = self.foodsAndKinds?.foods else { return }

    let realm = Realm.safeInit()

    realm!.safeWrite {

      for food in foods {
        realm!.add(food, update: .modified)
      }

      for kind in kinds {
        let predicate = NSPredicate(format: "kind_id == %i", kind.id)
        let foods = realm!.objects(Food.self).filter(predicate)
        kind.foods.removeAll()
        kind.foods.append(objectsIn: foods)

      realm!.add(kind, update: .modified)
      }
    }
    // print(realm.objects(Kind.self))

    guard let dataVersion = self.foodsAndKinds!.dataVersion else { return }
    UserDefaults.standard.setDataVersion(dataVersion: dataVersion)
    print("dataVersion:\(dataVersion) has saved.")

    // Post Notification
    NotificationCenter.default.postEvent(
      notification: NotificationEvent.foodsAndKindsUpdated, object: self, userInfo: nil)
  }

}
