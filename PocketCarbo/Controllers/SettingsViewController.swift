//
//  SettingsViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/03/23.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {

  @IBOutlet weak var versionLabel: UILabel!
  @IBOutlet weak var privacyPolicyCell: UITableViewCell!
  @IBOutlet weak var mailToDevCell: UITableViewCell!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    if let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
      versionLabel.text = version
    }
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

  //MARK: - Setup

  func setupGestures() {

    let tapGesturePrivacyPolicyCell = UITapGestureRecognizer(target: self, action: #selector(handleTapPrivacyPolicy(sender:)))
    privacyPolicyCell.addGestureRecognizer(tapGesturePrivacyPolicyCell)

    let tapGesturMailToDevCell = UITapGestureRecognizer(target: self, action: #selector(handleTapMailToDev(sender:)))
    mailToDevCell.addGestureRecognizer(tapGesturMailToDevCell)
  }

  //MARK: - Cell tap actions

  @objc func handleTapPrivacyPolicy(sender: UITapGestureRecognizer) {
    let informationController: UIViewController! = {
      let htmlPath = Bundle.main.path(forResource: "privacy_policy", ofType: "html")
      let url = URL(fileURLWithPath: htmlPath!)
      let vc = WebViewController(url: url, embed: false)
      vc.navigationItem.title = NSLocalizedString("Setting.privacy_policy", comment: "")
      return UINavigationController(rootViewController: vc)
    }()

    self.present(informationController, animated: true, completion: nil)
  }

  @objc func handleTapMailToDev(sender: UITapGestureRecognizer) {
    // TODO : 仮実装
    if !MFMailComposeViewController.canSendMail() {
      present(UIAlertController.alertWithTitle(title: "mail起動エラー", message: "メールの起動が出来ませんでした。\nお手数ですが\n sakurafish1@gmail.com\n宛にメールをお送りくださいませ。", buttonTitle: "OK"), animated: true, completion: nil)
      return
    }

    let mailViewController = MFMailComposeViewController()
    let toRecipients = ["sakurafish1@gmail.com"]

    mailViewController.mailComposeDelegate = self
    mailViewController.setSubject("【ポケット糖質量】ご意見・ご要望")
    mailViewController.setToRecipients(toRecipients)
    mailViewController.setMessageBody("ポケット糖質量へのご意見・ご要望をご記入ください。\nユーザー様のメールアドレスはこの連絡以外に使用することは一切ありません。\n返信が必要な場合、sakurafish1@gmail.comというメールアドレスよりお送りいたします。\n--------------------\n", isHTML: false)
    self.present(mailViewController, animated: true, completion: nil)
  }

  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }

}
