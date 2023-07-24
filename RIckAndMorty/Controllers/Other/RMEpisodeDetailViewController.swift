//
//  RMEpisodeDetailViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/24/23.
//

import UIKit

/// VS to show details about single episode
final class RMEpisodeDetailViewController: UIViewController {

  private let url: URL?

  //MARK: - Init

  init(url: URL?) {
    self.url = url

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  //MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Episode"
  }

}
