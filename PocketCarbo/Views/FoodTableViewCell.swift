//
//  FoodTableViewCell.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

protocol FoodTableViewCellDelegate: class {
  func didTapFavorites(_ sender: FoodTableViewCell)
  func didTapShare(_ sender: FoodTableViewCell, shareText: String)
}

class FoodTableViewCell: UITableViewCell {

  enum CellState {
    case collapsed
    case expanded

    var carretImage: UIImage {
      switch self {
      case .collapsed:
        return UIImage(named: "cell_carret_down")!
      case .expanded:
        return UIImage(named: "cell_carret_up")!
      }
    }
  }

  enum FavoritesState {
    case favorite
    case notFavorite

    var favoriteImage: UIImage {
      switch self {
      case .favorite:
        return UIImage(named: "cell_favorite_fill")!
      case .notFavorite:
        return UIImage(named: "cell_favorite_line")!
      }
    }
  }

  //MARK: Properties

  private let expandedViewIndex: Int = 1

  var cellState: CellState = .collapsed {
    didSet {
      toggle()
    }
  }

  var favoritesState: FavoritesState = .notFavorite {
    didSet {
      updateFavorites()
    }
  }

  weak var delegate: FoodTableViewCellDelegate?
  var food: Food = Food()

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var carretImage: UIImageView!
  @IBOutlet weak var foodNameLabel: UILabel!
  @IBOutlet weak var carboPer100gLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  @IBOutlet weak var favoritesButton: UIButton!
  @IBOutlet weak var copyToClipboardButton: UIButton!
  @IBOutlet weak var shareButton: UIButton!

  override func awakeFromNib() {
    selectionStyle = .none
    containerView.layer.cornerRadius = 5.0
  }

  func update(food: Food) {
    self.food = food

    foodNameLabel.text = food.name
    carboPer100gLabel.text = "\(food.carbohydrate_per_100g) g"
    let descriptionString = createDescriptionString(food: food)
    descriptionLabel.text = descriptionString
  }

  //MARK: Button Action

  @IBAction func didTapFavorites(_ sender: UIButton) {
    // TODO : ちゃんと実装する
    delegate?.didTapFavorites(self)//いらない？
    favoritesState = favoritesState == .favorite ? .notFavorite : .favorite

    sender.animateCellButton(completion: { (finish) in
      self.favoritesButton.setImage(self.favoritesState.favoriteImage, for: UIControlState.normal)
    })

  }

  @IBAction func didTapCopyToclipboard(_ sender: UIButton) {
    sender.animateCellButton(completion: { (finish) in
    })

    // TODO : ちゃんと実装する
    // https://github.com/devxoul/Toaster を使って表示したい
    let text = createClipboardText()
    UIPasteboard.general.string = text
    let toastText = "テキストをコピーしました\n\(text)"
    print(toastText)
  }
  
  @IBAction func didTapShare(_ sender: UIButton) {
    delegate?.didTapShare(self, shareText: createClipboardText())
    sender.animateCellButton(completion: { (finish) in
    })
  }

  //MARK: Private Methods

  private func toggle() {
    stackView.arrangedSubviews[expandedViewIndex].isHidden = stateIsCollapsed()
    carretImage.image = cellState.carretImage
  }

  private func stateIsCollapsed() -> Bool {
    return cellState == .collapsed
  }

  private func updateFavorites() {
    // TODO : ちゃんと実装する
    // update DB
  }

  private func createDescriptionString(food: Food) -> String {
    // TODO : string fileを使う

    var str: String = ""

    str.append("\(food.weight) g")
    if let hint = food.weight_hint {
      str.append(hint)
    }
    str.append("あたりの値\n")
    str.append("糖質 : \(food.carbohydrate_per_weight) g\n")
    str.append("カロリー : \(food.calory) g\n")
    str.append("たんぱく質 : \(food.protein) g\n")
    str.append("脂質 : \(food.fat) g\n")
    str.append("塩分 : \(food.sodium) g")

    return str
  }

  private func createClipboardText() -> String {
   var str: String = ""
    str.append(food.name!)
    str.append("100gあたりの糖質量:\(food.carbohydrate_per_100g)g, ")
    if let weight_hint = food.weight_hint {
      str.append(weight_hint)
    }
    if food.weight != 100 {
      str.append("\(food.weight)gあたりの糖質量:\(food.carbohydrate_per_weight)g, ")
    }
    str.append("カロリー:\(food.calory)g, ")
    str.append("たんぱく質:\(food.protein)g, ")
    str.append("脂質:\(food.fat)g, ")
    str.append("塩分:\(food.sodium)g ")
    str.append("#ポケット糖質量")

    return str
  }
}

extension UIButton {
  func animateCellButton(completion:@escaping ((Bool) -> Void)) {
    UIView.animate(withDuration: 0.1, animations: {
      self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) }, completion: { (finish: Bool) in
        UIView.animate(withDuration: 0.1, animations: {
          self.transform = CGAffineTransform.identity
          completion(finish)
        })
    })
  }
}
