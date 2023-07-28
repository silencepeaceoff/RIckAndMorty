//
//  RMLocationViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/13/23.
//

import UIKit

/// Controller to show and search for locations
final class RMLocationsViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    title = "Locations"
    addSearchButton()
  }

  private func addSearchButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .search,
      target: self,
      action: #selector(didTapShare)
    )
  }

  @objc
  private func didTapShare() {

  }
  
}
