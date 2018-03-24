//
//  SideMenuViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit

enum SideMenu: Int {
  case main = 0
  case favorites
  case settings
  case share
  case information
  case help

  var name: String {
    get { return String(describing: self) }
  }

}

struct SideMenuData {
  let icon: UIImage?
  let menuLabel: String?
}

protocol SideMenuProtocol : class {
  func changeViewController(_ menu: SideMenu)
}

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SideMenuProtocol {

  let cellIdentifier = "SideMenuCell"

  // instantiate from AppDelegate
  var mainViewController: UIViewController!

  // other scenes
  var favoritesViewController: UIViewController! = {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SideMenu.favorites.name) as! FavoritesViewController
    return UINavigationController(rootViewController: vc)
  }()
  var settingsController: UIViewController! = {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SideMenu.settings.name) as! SettingsViewController
    return UINavigationController(rootViewController: vc)
  }()
  var informationController: UIViewController! = {
    let vc = InformationViewController()
    vc.navigationItem.title = NSLocalizedString("Information.title", comment: "")
    return UINavigationController(rootViewController: vc)
  }()
  var helpController: UIViewController! = {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SideMenu.help.name) as! HelpViewController
    return UINavigationController(rootViewController: vc)
  }()

  // メニューアイコンと文言
  var sideMenuDatas: [SideMenuData] = {
    return [SideMenuData(icon: UIImage(named: "side_menu_home"), menuLabel: "Home"),
            SideMenuData(icon: UIImage(named: "side_menu_favorite"), menuLabel: "お気に入り"),
            SideMenuData(icon: UIImage(named: "side_menu_settings"), menuLabel: "設定"),
            SideMenuData(icon: UIImage(named: "side_menu_share"), menuLabel: "シェア"),
            SideMenuData(icon: UIImage(named: "side_menu_information"),
                         menuLabel: NSLocalizedString("Information.title", comment: "")),
            SideMenuData(icon: UIImage(named: "side_menu_help"), menuLabel: "ヘルプ")]
  }()

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.estimatedRowHeight = 60.0
    tableView.rowHeight = UITableViewAutomaticDimension
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sideMenuDatas.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideMenuTableViewCell else {
      fatalError("The dequeued cell is not an instance of LeftTableViewCell.")
    }
    cell.configureWithData(sideMenuDatas[indexPath.row])

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let menu = SideMenu(rawValue: indexPath.row) {
      self.changeViewController(menu)
    }
  }

  func changeViewController(_ menu: SideMenu) {
    switch menu {
    case .main:
      self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
    case .favorites:
      self.slideMenuController()?.changeMainViewController(self.favoritesViewController, close: true)
    case .settings:
      self.slideMenuController()?.changeMainViewController(self.settingsController, close: true)
    case .share:
      self.slideMenuController()?.closeLeft()
      share()
    case .information:
      self.slideMenuController()?.changeMainViewController(self.informationController, close: true)
    case .help:
      self.slideMenuController()?.changeMainViewController(self.helpController, close: true)
    }
  }

  func share() {
    let shareText = "#ポケット糖質量 http://www.pockettoushituryou.com/"
    let shareUrl = NSURL(string: "http://www.pockettoushituryou.com/")!

    let activityViewController : UIActivityViewController = UIActivityViewController(
      activityItems: [shareText, shareUrl], applicationActivities: nil)

    // This lines is for the popover you need to show in iPad
    activityViewController.popoverPresentationController?.sourceView = tableView

    // This line remove the arrow of the popover to show in iPad
    activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
    activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)

    // Anything you want to exclude
    activityViewController.excludedActivityTypes = [
      UIActivityType.assignToContact,
      UIActivityType.saveToCameraRoll,
      UIActivityType.addToReadingList,
    ]

    self.present(activityViewController, animated: true, completion: nil)
  }
}
