//
//  RMLocationDetailViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/31/23.
//

import UIKit

final class RMLocationDetailViewController: UIViewController, RMLocationDetailViewVMDelegate, RMLocationDetailViewDelegate {

  private let viewModel: RMLocationDetailViewVM
  private let detailView = RMLocationDetailView()

  //MARK: - Init

  init(location: RMLocation) {
    let url = URL(string: location.url)
    self.viewModel = RMLocationDetailViewVM(endpointUrl: url)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  //MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
    addConstraints()
  }

  private func setupView() {
    detailView.delegate = self
    view.backgroundColor = .systemBackground
    title = "Location"

    view.addSubview(detailView)

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .action,
      target: self,
      action: #selector(didTapShare)
    )

    viewModel.delegate = self
    viewModel.fetchLocationData()
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      detailView.topAnchor.constraint(equalTo: view.topAnchor),
      detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  @objc
  private func didTapShare() {

  }

  //MARK: - View Delegate

  func rmEpisodeDetailView(
    _ detailView: RMLocationDetailView,
    didSelect character: RMCharacter
  ) {
    let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
    vc.title = character.name
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }

  //MARK: - ViewModel Delegate

  func didFetchLocationDetails() {
    detailView.configure(with: viewModel)
  }

}
