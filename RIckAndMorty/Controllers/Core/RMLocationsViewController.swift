//
//  RMLocationViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/13/23.
//

import UIKit

/// Controller to show and search for locations
final class RMLocationsViewController: UIViewController, RMLocationViewVMDelegate, RMLocationViewDelegate {

  private let primaryView = RMLocationView()
  private let viewModel = RMLocationViewVM()

  //MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
    addConstraints()
  }

  private func setupView() {
    view.backgroundColor = .systemBackground
    title = "Locations"
    primaryView.delegate = self
    view.addSubview(primaryView)
    addSearchButton()
    viewModel.delegate = self
    viewModel.fetchLocations()
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      primaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      primaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
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
    let vc = RMSearchViewController(config: .init(type: .location))
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }

  //MARK: - RMLocationViewDelegate

  func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
    let vc = RMLocationDetailViewController(location: location)
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }

  //MARK: - LocationViewModelDelegate

  func didFetchInitialLocations() {
    primaryView.configure(with: viewModel)
  }
  
}
