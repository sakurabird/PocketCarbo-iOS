//
//  FoodsAndKinds.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/22.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation
class FoodsAndKinds: Codable {
  let dataVersion: Int?
  let kinds: [Kind]?
  let foods: [Food]?

  enum CodingKeys: String, CodingKey {
    case dataVersion = "data_version"
    case kinds = "kinds"
    case foods = "foods"
  }

  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    dataVersion = try values.decode(Int.self, forKey: .dataVersion)
    kinds = try values.decodeIfPresent([Kind].self, forKey: .kinds)
    foods = try values.decodeIfPresent([Food].self, forKey: .foods)
  }

}
