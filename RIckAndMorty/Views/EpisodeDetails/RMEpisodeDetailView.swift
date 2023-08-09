//
//  RMEpisodeDetailView.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/25/23.
//

import UIKit

protocol RMEpisodeDetailViewDelegate: AnyObject {
  func rmEpisodeDetailView(
    _ detailView: RMEpisodeDetailView,
    didSelect character: RMCharacter
  )
}

final class RMEpisodeDetailView: UIView {

  public weak var delegate: RMEpisodeDetailViewDelegate?

  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.hidesWhenStopped = true
    return spinner
  }()

  private var viewModel: RMEpisodeDetailViewVM? {
    didSet {
      spinner.stopAnimating()
      self.collectionView?.reloadData()
      self.collectionView?.isHidden = false
      UIView.animate(withDuration: 0.4) {
        self.collectionView?.alpha = 1
      }
    }
  }

  private var collectionView: UICollectionView?

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupView()
    addConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupporter")
  }

  private func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemBackground

    let collectionView = createCollectionView()
    self.collectionView = collectionView
    addSubviews(collectionView, spinner)
    spinner.startAnimating()
  }

  private func addConstraints() {
    guard let collectionView = collectionView else { return }

    NSLayoutConstraint.activate([
      spinner.heightAnchor.constraint(equalToConstant: 100),
      spinner.widthAnchor.constraint(equalTo: spinner.heightAnchor),
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func createCollectionView() -> UICollectionView {
    let layout = UICollectionViewCompositionalLayout { section, _ in
      return self.layout(for: section)
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.isHidden = true
    collectionView.alpha = 0
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier)
    collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
    return collectionView
  }

  //MARK: - Public

  public func configure(with viewModel: RMEpisodeDetailViewVM) {
    self.viewModel = viewModel
  }

}

extension RMEpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel?.cellViewModels.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let sections = viewModel?.cellViewModels else { return 0 }
    let sectionType = sections[section]

    switch sectionType {
    case .information(let viewModels):
      return viewModels.count
    case .characters(let viewModels):
      return viewModels.count
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let sections = viewModel?.cellViewModels else { fatalError("No viewModel") }
    let sectionType = sections[indexPath.section]

    switch sectionType {
    case .information(let viewModels):
      let cellViewModels = viewModels[indexPath.row]
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as? RMEpisodeInfoCollectionViewCell else { fatalError() }
      cell.configure(with: cellViewModels)
      return cell

    case .characters(let viewModels):
      let cellViewModels = viewModels[indexPath.row]
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as? RMCharacterCollectionViewCell else { fatalError() }
      cell.configure(with: cellViewModels)
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    guard let viewModel = viewModel else { return }
    let sections = viewModel.cellViewModels
    let sectionType = sections[indexPath.section]

    switch sectionType {
    case .information:
      break

    case .characters:
      guard let character = viewModel.character(at: indexPath.row) else { return }
      delegate?.rmEpisodeDetailView(self, didSelect: character)
    }
  }

}

extension RMEpisodeDetailView {

  private func layout(for section: Int) -> NSCollectionLayoutSection {
    guard let sections = viewModel?.cellViewModels else { return createInfoLayout() }

    switch sections[section] {
    case .information:
      return createInfoLayout()
    case .characters:
      return createCharacterLayout()
    }
  }

  private func createInfoLayout() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      )
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .absolute(80)),
      subitems: [item]
    )
    let section = NSCollectionLayoutSection(group: group)

    return section
  }

  private func createCharacterLayout() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.5 : 0.25),
        heightDimension: .fractionalHeight(1)
      )
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .absolute(UIDevice.isiPhone ? 300 : 360)),
      subitems: UIDevice.isiPhone ? [item, item] : [item, item, item, item]
    )
    let section = NSCollectionLayoutSection(group: group)

    return section
  }

}
