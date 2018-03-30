//
//  FoodTableViewCell.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import Toaster

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

    setupViews()
  }

  func update(food: Food) {
    self.food = food

    foodNameLabel.text = food.name
    foodNameLabel.textColor = getCarboColor()
    carboPer100gLabel.text = "\(food.carbohydrate_per_100g) g"
    carboPer100gLabel.textColor = getCarboColor()
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

    let text = createClipboardText()
    UIPasteboard.general.string = text
    let toastText = String(format: NSLocalizedString("Foods.text.copied", comment: ""), text)
    Toast(text: toastText, duration: Delay.long).show()
  }
  
  @IBAction func didTapShare(_ sender: UIButton) {
    delegate?.didTapShare(self, shareText: createClipboardText())
    sender.animateCellButton(completion: { (finish) in
    })
  }

  //MARK: Private Methods

  private func setupViews() {
    selectionStyle = .none
    backgroundColor = UIColor.clear

    // Add shadow to cell
    containerView.layer.cornerRadius = 5.0
    containerView.layer.borderWidth = 1
    containerView.layer.borderColor = UIColor.clear.cgColor
    containerView.layer.masksToBounds = true

    self.layer.shadowOpacity = 0.18
    self.layer.shadowOffset = CGSize(width: 0, height: 2)
    self.layer.shadowRadius = 2
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.masksToBounds = false
  }

  private func toggle() {
    stackView.arrangedSubviews[expandedViewIndex].isHidden = stateIsCollapsed()
    carretImage.image = cellState.carretImage
  }

  private func stateIsCollapsed() -> Bool {
    return cellState == .collapsed
  }

  private func getCarboColor() -> UIColor {
    switch self.food.carbohydrate_per_100g {
    case 0 ..< 5:
      // 糖質量が少ない
      return UIColor(rgb: 0x0000d2)
    case 5 ..< 15:
      // 糖質量がやや多い
      return UIColor(rgb: 0x049336)
    case 15 ..< 50:
      // 糖質量が多い
      return UIColor(rgb: 0xf44336)
    default:
      // 糖質量が非常に多い
      return UIColor(rgb: 0x9c27b0)
    }
  }

  private func updateFavorites() {
    // TODO : ちゃんと実装する
    // update DB
  }

  private func createDescriptionString(food: Food) -> String {

    var str: String = ""

    str.append("\(food.weight) g")
    if let hint = food.weight_hint {
      str.append(hint)
    }

    str.append(NSLocalizedString("Foods.description.text1", comment: ""))
    str.append(String(format: NSLocalizedString("Foods.description.text2", comment: ""), String(food.carbohydrate_per_weight)))
    str.append(String(format: NSLocalizedString("Foods.description.text3", comment: ""), String(food.calory)))
    str.append(String(format: NSLocalizedString("Foods.description.text4", comment: ""), String(food.protein)))
    str.append(String(format: NSLocalizedString("Foods.description.text5", comment: ""), String(food.fat)))
    str.append(String(format: NSLocalizedString("Foods.description.text6", comment: ""), String(food.sodium)))

    return str
  }

  private func createClipboardText() -> String {
   var str: String = ""
    str.append(food.name!)
    str.append(String(format: NSLocalizedString("Foods.clipboard.text1", comment: ""), String(food.carbohydrate_per_100g)))
    if let weight_hint = food.weight_hint {
      str.append(weight_hint)
    }
    if food.weight != 100 {
      str.append(String(format: NSLocalizedString("Foods.clipboard.text2", comment: ""), String(food.weight), String(food.carbohydrate_per_weight)))
    }
    str.append(String(format: NSLocalizedString("Foods.clipboard.text3", comment: ""), String(food.calory)))
    str.append(String(format: NSLocalizedString("Foods.clipboard.text4", comment: ""), String(food.protein)))
    str.append(String(format: NSLocalizedString("Foods.clipboard.text5", comment: ""), String(food.fat)))
    str.append(String(format: NSLocalizedString("Foods.clipboard.text6", comment: ""), String(food.sodium)))

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
