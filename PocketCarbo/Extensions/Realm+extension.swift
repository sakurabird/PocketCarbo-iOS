//
//  Realm+extension.swift
//  PocketCarbo
//
//  Created by Sakura on 2021/06/14.
//  Copyright © 2021 Sakura. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
  static func safeInit() -> Realm? {
    do {
      let realm = try Realm()
      return realm
    } catch {
      print("Realm init failed with error: \(error)")
    }
    return nil
  }

  func safeWrite(_ block: () -> Void) {
    do {
      // Async safety, to prevent "Realm already in a write transaction" Exceptions
      if !isInWriteTransaction {
        try write(block)
      }
    } catch {
      print("Realm write failed with error: \(error)")
    }
  }
}
