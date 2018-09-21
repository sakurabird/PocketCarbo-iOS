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
  // Foods scene
  var mainViewController: UIViewController!

  // Favorites scene
  var favoritesViewController: UIViewController! = {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SideMenu.favorites.name) as! FavoritesViewController
    vc.navigationItem.title = NSLocalizedString("Favorite.title", comment: "")
    return UINavigationController(rootViewController: vc)
  }()

  // Settings scene
  var settingsController: UIViewController! = {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SideMenu.settings.name) as! SettingsViewController
    vc.navigationItem.title = NSLocalizedString("Setting.title", comment: "")
    return UINavigationController(rootViewController: vc)
  }()

  // Information scene
  var informationController: UIViewController! = {
    let htmlPath = Bundle.main.path(forResource: "announcement", ofType: "html")
    let url = URL(fileURLWithPath: htmlPath!)
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SideMenu.information.name) as! WebViewController
    vc.setUp(url: url, embed: true)
    vc.navigationItem.title = NSLocalizedString("Information.title", comment: "")
    return UINavigationController(rootViewController: vc)
  }()
  
  // Help scene
  var helpController: UIViewController! = {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SideMenu.help.name) as! HelpViewController
    vc.navigationItem.title = NSLocalizedString("Help.title", comment: "")
    return UINavigationController(rootViewController: vc)
  }()

  // メニューアイコンと文言
  var sideMenuDatas: [SideMenuData] = {
    return [SideMenuData(icon: UIImage(named: "side_menu_home"),
                         menuLabel: NSLocalizedString("Foods.sidemenu.title", comment: "")),
            SideMenuData(icon: UIImage(named: "side_menu_favorite"),
                         menuLabel: NSLocalizedString("Favorite.title", comment: "")),
            SideMenuData(icon: UIImage(named: "side_menu_settings"),
                         menuLabel: NSLocalizedString("Setting.title", comment: "")),
            SideMenuData(icon: UIImage(named: "side_menu_share"),
                         menuLabel: NSLocalizedString("share", comment: "")),
            SideMenuData(icon: UIImage(named: "side_menu_information"),
                         menuLabel: NSLocalizedString("Information.title", comment: "")),
            SideMenuData(icon: UIImage(named: "side_menu_help"),
                         menuLabel: NSLocalizedString("Help.title", comment: ""))]
  }()

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.estimatedRowHeight = 70.0
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
      fatalError("The dequeued cell is not an instance of SideMenuTableViewCell.")
    }
    cell.configureWithData(sideMenuDatas[indexPath.row])

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let menu = SideMenu(rawValue: indexPath.row) {
      self.changeViewController(menu)
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56
  }

  //MARK: - Side Menu Controller

  func changeViewController(_ menu: SideMenu) {
    switch menu {
    case .main:
      self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)

    case .favorites:
      let nav = self.favoritesViewController as! UINavigationController
      let vc = nav.topViewController as! FavoritesViewController
      vc.updateFavorites()
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

  private func share() {
    guard let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String else {
      return
    }
    let shareText = "#\(appName)"
    let shareUrl = NSURL(string: NSLocalizedString("appStoreWebURL", comment: ""))!

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
