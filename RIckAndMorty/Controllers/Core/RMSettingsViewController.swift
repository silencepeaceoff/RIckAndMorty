//
//  RMSettingsViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/13/23.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit

/// Controller to show various app options and settings
final class RMSettingsViewController: UIViewController {

  private var settingsSwiftUIController: UIHostingController<RMSettingsView>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    title = "Settings"
    addSwiftUIController()
  }

  private func addSwiftUIController() {
    let settingsSwiftUIController = UIHostingController(
      rootView: RMSettingsView(viewModel: RMSettingsViewVM(
        cellViewModels: RMSettingsOption.allCases.compactMap({
          return RMSettingsCellVM(type: $0) { [weak self] option in
            self?.handleTap(option: option)
          }
        })
      ))
    )

    addChild(settingsSwiftUIController)
    settingsSwiftUIController.didMove(toParent: self)

    view.addSubview(settingsSwiftUIController.view)
    settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.topAnchor),
      settingsSwiftUIController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      settingsSwiftUIController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    self.settingsSwiftUIController = settingsSwiftUIController
  }

  private func handleTap(option: RMSettingsOption) {
    guard Thread.current.isMainThread else { return }
    if let url = option.targetUrl {
      let vc = SFSafariViewController(url: url)
      present(vc, animated: true)
    } else if option == .rateApp {
      if let windowScene = view.window?.windowScene {
        SKStoreReviewController.requestReview(in: windowScene)
      }
    }
  }

}
