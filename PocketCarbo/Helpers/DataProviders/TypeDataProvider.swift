//
//  TypeDataProvider.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation

final class TypeDataProvider {

  private init() { }
  static let sharedInstance = TypeDataProvider()

  func findAll() -> [Type] {
    
    let path = Bundle.main.path(forResource: "type", ofType: "json")
    let url = URL(fileURLWithPath: path!)
    var types: [Type] = [Type]()
    
    do {
      let data = try Data(contentsOf: url)
      let typeArray = try JSONDecoder().decode(Types.self, from: data)
      types = typeArray.types!
    } catch  {
      print(error)
    }
    return types
  }
}
