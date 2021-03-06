//
//  AppDelegate.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/21.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCrashlytics
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Google Service
    FirebaseApp.configure()

    // Setup Admob
    ADManager.sharedInstance.setupAdMob()

    // Check Data Version and Update If Needed
    AppLaunchManager.sharedInstance.onAppStarted()

    setupSlideMenu()

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UserDefaults.standard.setFirstLaunch(firstLaunch: false)
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  // MARK: - Private method

  // サイドバーにコントローラーを割り当てる
  private func setupSlideMenu() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    guard let mainVC: MainParentViewController =  storyboard.instantiateViewController(withIdentifier: "MainParent") as? MainParentViewController
      else {
        fatalError("The storyboard controller is not an instance of MainParentViewController.")
    }
    guard let sideMenuVC: SideMenuViewController =  storyboard.instantiateViewController(withIdentifier: "SideMenu") as? SideMenuViewController
      else {
        fatalError("The storyboard controller is not an instance of SideMenuViewController.")
    }

    // NavigationBar
    let navigationController = UINavigationController(rootViewController: mainVC)

    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().barTintColor = UIColor(named: "ColorPrimary")
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    sideMenuVC.mainViewController = navigationController

    let slideMenuController = SlideMenuController(mainViewController: navigationController, leftMenuViewController: sideMenuVC)
    SlideMenuOptions.contentViewScale = 1

    self.window?.rootViewController = slideMenuController
    self.window?.makeKeyAndVisible()
  }
}
