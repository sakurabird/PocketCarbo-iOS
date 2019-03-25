//
//  Food.swift
//  PocketCarbo
//  
//
//  Created by Sakura on 2018/03/22.
//

import Foundation
import RealmSwift

class Food: RealmSwift.Object, Codable {
  @objc dynamic var id: Int = 0
  @objc dynamic var name: String?
  @objc dynamic var carbohydrate_per_100g: Float = 0
  @objc dynamic var carbohydrate_per_weight: Float = 0
  @objc dynamic var weight: Float = 0
  @objc dynamic var calory: Float = 0
  @objc dynamic var protein: Float = 0
  @objc dynamic var fat: Float = 0
  @objc dynamic var sodium: Float = 0
  @objc dynamic var notes: String?
  @objc dynamic var type_id: Int = 0
  @objc dynamic var kind_id: Int = 0
  @objc dynamic var search_word: String?
  @objc dynamic var weight_hint: String?

  let kinds = LinkingObjects(fromType: Kind.self, property: "foods")

  enum CodingKeys: String, CodingKey {

    case id
    case name
    case carbohydrate_per_100g
    case carbohydrate_per_weight
    case weight
    case calory
    case protein
    case fat
    case sodium
    case notes
    case type_id
    case kind_id
    case search_word
    case weight_hint
  }

  required convenience init(from decoder: Decoder) throws {
    self.init()
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .id)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    carbohydrate_per_100g = try values.decode(Float.self, forKey: .carbohydrate_per_100g)
    carbohydrate_per_weight = try values.decode(Float.self, forKey: .carbohydrate_per_weight)
    weight = try values.decode(Float.self, forKey: .weight)
    calory = try values.decode(Float.self, forKey: .calory)
    protein = try values.decode(Float.self, forKey: .protein)
    fat = try values.decode(Float.self, forKey: .fat)
    sodium = try values.decode(Float.self, forKey: .sodium)
    notes = try values.decodeIfPresent(String.self, forKey: .notes)
    type_id = try values.decode(Int.self, forKey: .type_id)
    kind_id = try values.decode(Int.self, forKey: .kind_id)
    search_word = try values.decodeIfPresent(String.self, forKey: .search_word)
    weight_hint = try values.decodeIfPresent(String.self, forKey: .weight_hint)
  }

  override static func primaryKey() -> String? {
    return "id"
  }
}
