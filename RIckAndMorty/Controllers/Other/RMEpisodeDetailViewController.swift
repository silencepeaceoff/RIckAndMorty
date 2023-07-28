//
//  RMEpisodeDetailViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/24/23.
//

import UIKit

/// VS to show details about single episode
final class RMEpisodeDetailViewController: UIViewController, RMEpisodeDetailViewVMDelegate, RMEpisodeDetailViewDelegate {

  private let viewModel: RMEpisodeDetailViewVM
  private let detailView = RMEpisodeDetailView()

  //MARK: - Init

  init(url: URL?) {
    self.viewModel = RMEpisodeDetailViewVM(endpointUrl: url)
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
    title = "Episode"

    view.addSubview(detailView)

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .action,
      target: self,
      action: #selector(didTapShare)
    )

    viewModel.delegate = self
    viewModel.fetchEpisodeData()
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
    _ detailView: RMEpisodeDetailView,
    didSelect character: RMCharacter
  ) {
    let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
    vc.title = character.name
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }

  //MARK: - ViewModel Delegate

  func didFetchEpisodeDetails() {
    detailView.configure(with: viewModel)
  }

}
