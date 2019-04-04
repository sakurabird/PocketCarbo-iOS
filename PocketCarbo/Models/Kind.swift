//
//  Kind.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/22.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation
import RealmSwift

class Kind: RealmSwift.Object, Codable {
  @objc dynamic var id: Int = 0
  @objc dynamic var name: String?
  @objc dynamic var search_word: String?
  @objc dynamic var type_id: Int = 0

  let foods = List<Food>()

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case search_word
    case type_id
  }

  required convenience init(from decoder: Decoder) throws {
    self.init()
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = (try values.decodeIfPresent(Int.self, forKey: .id))!
    name = try values.decodeIfPresent(String.self, forKey: .name)
    search_word = try values.decodeIfPresent(String.self, forKey: .search_word)
    type_id = (try values.decodeIfPresent(Int.self, forKey: .type_id))!
  }

  override static func primaryKey() -> String? {
    return "id"
  }
}
