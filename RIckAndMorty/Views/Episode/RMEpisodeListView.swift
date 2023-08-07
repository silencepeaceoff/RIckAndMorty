//
//  RMEpisodeListView.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/25/23.
//

import UIKit

protocol RMEpisodeListViewDelegate: AnyObject {
  func rmEpisodeListView(
    _ characterListView: RMEpisodeListView,
    didSelectCharacter episode: RMEpisode
  )
}

/// View that handles showing list of characters, loader etc.
final class RMEpisodeListView: UIView {

  public weak var delegate: RMEpisodeListViewDelegate?

  private let viewModel = RMEpisodeListViewVM()

  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.hidesWhenStopped = true
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isHidden = true
    collectionView.alpha = 0
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(
      RMCharacterEpisodeCollectionViewCell.self,
      forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier
    )
    collectionView.register(
      RMFooterLoadingCollectionReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier
    )
    return collectionView
  }()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)

    translatesAutoresizingMaskIntoConstraints = false
    addSubviews(collectionView, spinner)

    addConstraints()
    spinner.startAnimating()
    viewModel.delegate = self
    viewModel.fetchEpisodes()
    setupCollectionView()
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      spinner.widthAnchor.constraint(equalToConstant: 100),
      spinner.heightAnchor.constraint(equalTo: spinner.widthAnchor),
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func setupCollectionView() {
    collectionView.delegate = viewModel
    collectionView.dataSource = viewModel
  }

}

extension RMEpisodeListView: RMEpisodeListViewVMDelegate {

  func didSelectEpisode(_ episode: RMEpisode) {
    delegate?.rmEpisodeListView(self, didSelectCharacter: episode)
  }

  func didLoadInitialEpisodes() {
    spinner.stopAnimating()
    collectionView.isHidden = false
    collectionView.reloadData()

    UIView.animate(withDuration: 0.4) {
      self.collectionView.alpha = 1
    }
  }

  func didLoadMoreEpisodes(with newIndexPath: [IndexPath]) {
    collectionView.performBatchUpdates {
      self.collectionView.insertItems(at: newIndexPath)
    }
  }

}

