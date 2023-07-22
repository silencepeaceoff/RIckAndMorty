//
//  RMCharacterViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/13/23.
//

import UIKit

/// Controller to show and search for characters
final class RMCharactersViewController: UIViewController {

  private let characterListView = RMCharacterListView()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
  }

  private func setupView() {
    view.backgroundColor = .systemBackground
    title = "Characters"

    characterListView.delegate = self

    view.addSubview(characterListView)
    NSLayoutConstraint.activate([
      characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
}

extension RMCharactersViewController: RMCharacterListViewDelegate {

  func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
    // Open controller for that character
    let viewModel = RMCharacterDetailViewVM(character: character)
    let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
    detailVC.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(detailVC, animated: true)
  }

}
