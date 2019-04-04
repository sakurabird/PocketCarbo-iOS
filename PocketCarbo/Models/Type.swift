//
//  Type.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation

class Types: Codable {
  let types: [Type]?

  enum CodingKeys: String, CodingKey {
    case types
  }

  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    types = try values.decodeIfPresent([Type].self, forKey: .types)
  }

}

class Type: Codable {
  let id: Int?
  let name: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
  }

  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id = try values.decode(Int.self, forKey: .id)
    name = try values.decodeIfPresent(String.self, forKey: .name)
  }

}
