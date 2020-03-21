//
//  SettingsViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import MessageUI
import Device

class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {

  @IBOutlet weak var versionLabel: UILabel!
  @IBOutlet weak var privacyPolicyCell: UITableViewCell!
  @IBOutlet weak var mailToDevCell: UITableViewCell!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    versionLabel.text = Bundle.main.releaseVersionNumber
    setupGestures()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNavigationBarItem()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  // MARK: - Setup

  func setupGestures() {

    let tapGesturePrivacyPolicyCell = UITapGestureRecognizer(target: self, action: #selector(handleTapPrivacyPolicy(sender:)))
    privacyPolicyCell.addGestureRecognizer(tapGesturePrivacyPolicyCell)

    let tapGesturMailToDevCell = UITapGestureRecognizer(target: self, action: #selector(handleTapMailToDev(sender:)))
    mailToDevCell.addGestureRecognizer(tapGesturMailToDevCell)
  }

  // MARK: - Cell tap actions

  @objc func handleTapPrivacyPolicy(sender: UITapGestureRecognizer) {
    let informationController: UIViewController! = {
      let htmlPath = Bundle.main.path(forResource: "privacy_policy", ofType: "html")
      let url = URL(fileURLWithPath: htmlPath!)

      guard let vc: WebViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SideMenu.information.name) as? WebViewController
        else {
          fatalError("The controller is not an instance of WebViewController.")
      }
      vc.setUp(url: url, embed: false)
      vc.navigationItem.title = NSLocalizedString("Setting.privacy_policy", comment: "")
      return UINavigationController(rootViewController: vc)
    }()

    self.present(informationController, animated: true, completion: nil)
  }

   @objc func handleTapMailToDev(sender: UITapGestureRecognizer) {

     if !MFMailComposeViewController.canSendMail() {
       let title: String = NSLocalizedString("Setting.mail.error.title", comment: "")
       let message: String = NSLocalizedString("Setting.mail.error.message", comment: "")
       present(UIAlertController.alertWithTitle(title: title, message: message, buttonTitle: "OK"), animated: true, completion: nil)
       return
     }

     let mail: String = NSLocalizedString("mail", comment: "")
     let subject: String = NSLocalizedString("Setting.mail.subject", comment: "")
     let appVersion = Bundle.main.releaseVersionNumber ?? ""
     let deviceModel = Device.version().rawValue
     let osVersion = UIDevice.current.systemVersion
     let body = String(format: NSLocalizedString("Setting.mail.messageBody", comment: ""), appVersion, deviceModel, osVersion)

     let mailViewController = MFMailComposeViewController()
     let toRecipients = [mail]

     mailViewController.mailComposeDelegate = self
     mailViewController.setSubject(subject)
     mailViewController.setToRecipients(toRecipients)
     mailViewController.setMessageBody(body, isHTML: false)

     self.present(mailViewController, animated: true, completion: nil)
   }

  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }

}
