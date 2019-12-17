//
//  AdBannerViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/09/07.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdBannerViewController: UIViewController, GADBannerViewDelegate {

  // MARK: - Properties

  @IBOutlet weak var adBannerView: GADBannerView!

  var observer: NSKeyValueObservation?

  var startDisplayADTask: DispatchWorkItem!

  var clickedFrom = false

  // MARK: - Properties

  deinit {
    finishInterval()
    NotificationCenter.default.removeObserver(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "main_bg")!)

    // observe Users AD click events
    NotificationCenter.default.observeEvent(observer: self,
                                            selector: #selector(hideAD),
                                            notification: NotificationEvent.userClickedADBanner)
    setupAdMob()
  }

  // MARK: - GADBannerViewDelegate

  func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
    //　User clicked banner
    clickedFrom = true
    startInterval(clicked: true)
  }

  // MARK: - Private functions

  @objc
  private func hideAD() {
    // cought a notification of users AD click events
    if clickedFrom {
      clickedFrom = false
      return
    }

    if !ADManager.sharedInstance.isIntervalOK() {
      self.finishInterval()
      self.startInterval(clicked: false)
    }
  }

  private func setupAdMob() {
    adBannerView.adUnitID = ADManager.sharedInstance.getBannerId()
    adBannerView.rootViewController = self
    adBannerView.delegate = self

    finishInterval()

    if ADManager.sharedInstance.isIntervalOK() {
      displayView(isHidden: false)
    } else {
      // 前回起動時にクリックされた場合でも1時間以内であれば広告を表示しない
      startInterval(clicked: false)
    }
  }

  private func displayView(isHidden: Bool) {
    adBannerView.isHidden = isHidden
    if !isHidden {
      adBannerView.load(GADRequest())
    }
  }

  private func startInterval(clicked: Bool) {
    displayView(isHidden: true)

    let now = Date()

    if clicked {
      UserDefaults.standard.setlastADClickDate(lastADClickDate: now)
      // Post Notification
      NotificationCenter.default.postEvent(
        notification: NotificationEvent.userClickedADBanner, object: self, userInfo: nil)
    }

    let intervalSeconds = ADManager.sharedInstance.culculateIntervalTimeSeconds(now: now)

    startDisplayADTask = DispatchWorkItem {
      self.displayView(isHidden: false)
    }
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + intervalSeconds, execute: startDisplayADTask)
  }

  private func finishInterval() {
    if let startDisplayADTask = self.startDisplayADTask {
      startDisplayADTask.cancel()
    }
  }
}
