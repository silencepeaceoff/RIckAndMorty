//
//  RMCharacterDetailView.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/20/23.
//

import UIKit

/// View for single character info
final class RMCharacterDetailView: UIView {

  public var collectionView: UICollectionView?

  private let viewModel: RMCharacterDetailViewVM

  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.hidesWhenStopped = true
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()

  //MARK: - Init

  init(frame: CGRect, viewModel: RMCharacterDetailViewVM) {
    self.viewModel = viewModel
    super.init(frame: frame)
    
    backgroundColor = .systemBackground
    translatesAutoresizingMaskIntoConstraints = false
    let collectionView = createCollectionView()
    self.collectionView = collectionView
    addSubviews(collectionView, spinner)
    addConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  private func addConstraints() {
    guard let collectionView = collectionView else {
      return
    }

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

  private func createCollectionView() -> UICollectionView {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
      return self.createSection(for: sectionIndex)
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(RMCharacterPhotoCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifire)
    collectionView.register(RMCharacterInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifire)
    collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }

  private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
    let sectionTypes = viewModel.sections
    switch sectionTypes[sectionIndex] {
    case .photo:
      return viewModel.createPhotoSectionLayout()
    case .information:
      return viewModel.createInfoSectionLayout()
    case .episodes:
      return viewModel.createEpisodeSectionLayout()
    }
  }
  
}
