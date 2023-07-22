//
//  RMCharacterDetailViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/20/23.
//

import UIKit

/// Controllet to show info about single character
final class RMCharacterDetailViewController: UIViewController {

  private let viewModel: RMCharacterDetailViewVM

  init(viewModel: RMCharacterDetailViewVM) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  //MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    title = viewModel.title
  }

}
