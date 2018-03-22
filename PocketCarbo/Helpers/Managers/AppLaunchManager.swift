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

    setupRealm()

    if !newDataVersion() {
      return
    }

    loadJsonFile()
    saveDB()
  }


  //MARK: Private Methods

  private func setupRealm() {
    var config = Realm.Configuration()
    config.deleteRealmIfMigrationNeeded = true
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
    } catch  {
      print(error)
    }
  }

  private func saveDB() {
    guard let kinds = self.foodsAndKinds?.kinds else { return }
    guard let foods = self.foodsAndKinds?.foods else { return }

    let realm = try! Realm()

    try! realm.write {
      for kind in kinds {
        realm.add(kind, update: true)
      }
      for food in foods {
        realm.add(food, update: true)
      }
    }

    guard let dataVersion = self.foodsAndKinds!.dataVersion else { return }
    UserDefaults.standard.setDataVersion(dataVersion: dataVersion)
    print("dataVersion:\(dataVersion) has saved.")
//    print(realm.objects(Food.self))
  }

}
