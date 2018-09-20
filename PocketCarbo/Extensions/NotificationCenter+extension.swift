//
//  Notification+extention.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/22.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import Foundation

enum NotificationEvent: String {
  case foodsAndKindsUpdated
  case userClickedADBanner
}

extension NotificationCenter {

  func observeEvent(observer: Any, selector: Selector,
           notification: NotificationEvent, object: Any? = nil) {
    addObserver(observer, selector: selector,
                name: Notification.Name(notification.rawValue),
                object: object)
  }

  func postEvent(notification: NotificationEvent,
            object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
    post(name: NSNotification.Name(rawValue: notification.rawValue),
         object: object, userInfo: userInfo)
  }
  
}
