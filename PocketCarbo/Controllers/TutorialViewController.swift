//
//  TutorialViewController.swift
//  PocketCarbo
//
//  Created by Sakura on 2018/04/08.
//  Copyright © 2018年 Sakura. All rights reserved.
//

import UIKit
import Gecco
import Toaster

class TutorialViewController: SpotlightViewController {

  @IBOutlet var annotationViews: [UIView]!
  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var skipDescription: UIStackView!

  var stepIndex: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    delegate = self
    UserDefaults.standard.setTutorialShowing(tutorialShowing: true)

    setupTapGesture()
  }

  // MARK: - deinit

  deinit {
    UserDefaults.standard.setTutorialShowing(tutorialShowing: false)
  }

  // MARK: - Setup

  private func setupTapGesture() {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(TutorialViewController.viewTouched(_:)))
    view.addGestureRecognizer(gesture)
  }

  @objc func viewTouched(_ gesture: UITapGestureRecognizer) {
    // Show next annotation
    next(true)
 }

  // MARK: Button Action

  @IBAction func onClickSkipButton(_ sender: Any) {
    let toastText = NSLocalizedString("Foods.tutorial.skip", comment: "")
    Toast(text: toastText, duration: Delay.short).show()

    dismiss(animated: true, completion: nil)

    ADManager.sharedInstance.showATTAuthorizationAlart()
  }

  // MARK: - Gecco control

  func next(_ labelAnimated: Bool) {
    updateAnnotationView(labelAnimated)

    let screenSize = UIScreen.main.bounds.size

    var topMargin = 0
    if (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)! > CGFloat(0.0) {
      topMargin += 24
    }

    switch stepIndex {
    case 0:
      // Menu
      let y = 40 + topMargin
      spotlightView.appear(Spotlight.Oval(center: CGPoint(x: 30, y: y), diameter: 56))
    case 1:
      // Search
      let y = 40 + topMargin
      spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width - 30, y: CGFloat(y)), diameter: 56), moveType: .disappear)
    case 2:
      // Tab
      let y = 90 + topMargin
      spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width / 2, y: CGFloat(y)), size: CGSize(width: screenSize.width, height: 60), cornerRadius: 6), moveType: .disappear)
    case 3:
      // Kind
      let y = 148 + topMargin
      spotlightView.move(Spotlight.Rect(center: CGPoint(x: screenSize.width / 3.12, y: CGFloat(y)), size: CGSize(width: screenSize.width / 1.25, height: 60)), moveType: .disappear)
    case 4:
      // Sort
      let y = 148 + topMargin
      spotlightView.move(Spotlight.Rect(center: CGPoint(x: screenSize.width / 1.16, y: CGFloat(y)), size: CGSize(width: screenSize.width / 3.5, height: 60)), moveType: .disappear)
    case 5:
      // Cell
      spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width / 2, y: screenSize.height / 2), size: CGSize(width: 0, height: 0), cornerRadius: 0), moveType: .disappear)
    case 6:
      // Text Color & Thanks
      skipButton.alpha = 0
      skipDescription.alpha = 0

      spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width / 2, y: screenSize.height / 2), size: CGSize(width: 0, height: 0), cornerRadius: 0), moveType: .disappear)
    case 7:
      dismiss(animated: true, completion: nil)
      ADManager.sharedInstance.showATTAuthorizationAlart()
    default:
      break
    }

    stepIndex += 1
  }
  func updateAnnotationView(_ animated: Bool) {
    annotationViews.enumerated().forEach { index, view in
      UIView.animate(withDuration: animated ? 0.25 : 0) {
        view.alpha = index == self.stepIndex ? 1 : 0
      }
    }
  }
}

// MARK: - SpotlightViewControllerDelegate

extension TutorialViewController: SpotlightViewControllerDelegate {
  func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
    next(false)
  }

  func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
    next(true)
  }

  func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
    spotlightView.disappear()
  }
}
