//
//  RMEpisodeViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/13/23.
//

import UIKit

/// Controller to show and search for episodes
final class RMEpisodesViewController: UIViewController {
  
  private let episodeListView = RMEpisodeListView()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
    addConstraints()
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

  private func setupView() {
    episodeListView.delegate = self

    view.backgroundColor = .systemBackground
    title = "Episodes"
    view.addSubview(episodeListView)
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      episodeListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      episodeListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

}

extension RMEpisodesViewController: RMEpisodeListViewDelegate {

  func rmEpisodeListView(_ characterListView: RMEpisodeListView, didSelectCharacter episode: RMEpisode) {
    // Open controller for that episode
    let detailVC = RMEpisodeDetailViewController(url: URL(string: episode.url))
    detailVC.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(detailVC, animated: true)
  }

}

