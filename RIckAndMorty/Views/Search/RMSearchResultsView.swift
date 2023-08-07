//
//  RMSearchResultsView.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 8/7/23.
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
  func rmSearchResultsView(
    _ resultsView: RMSearchResultsView,
    didTapLocationAt index: Int
  )
}

/// Shows search results UI (table or collection as needed)
final class RMSearchResultsView: UIView {

  weak var delegate: RMSearchResultsViewDelegate?

  private var viewModel: RMSearchResultVM? {
    didSet {
      self.processViewModel()
    }
  }

  private let tableView: UITableView = {
    let table = UITableView()
    table.register(
      RMLocationTableViewCell.self,
      forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier
    )
    table.isHidden = true
    table.translatesAutoresizingMaskIntoConstraints = false
    return table
  }()

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isHidden = true
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(
      RMCharacterCollectionViewCell.self,
      forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier
    )
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

  private var locationCellViewModels: [RMLocationTableViewCellVM] = []
  private var collectionViewCellVM: [any Hashable] = []

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    isHidden = true
    addSubviews(tableView, collectionView)
    addConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func processViewModel() {
    guard let viewModel = viewModel else { return }
    switch viewModel {
    case .characters(let viewModels):
      self.collectionViewCellVM = viewModels
      setupCollectionView()
    case .locations(let viewModels):
      setupTableView(viewModels: viewModels)
    case .episodes(let viewModels):
      self.collectionViewCellVM = viewModels
      setupCollectionView()
    }
  }

  private func setupCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    tableView.isHidden = true
    collectionView.isHidden = false
    collectionView.reloadData()
  }

  private func setupTableView(viewModels: [RMLocationTableViewCellVM]) {
    tableView.delegate = self
    tableView.dataSource = self
    collectionView.isHidden = true
    tableView.isHidden = false
    self.locationCellViewModels = viewModels
    tableView.reloadData()
  }

  public func configure(with viewModel: RMSearchResultVM) {
    self.viewModel = viewModel
  }

}

//MARK: - TableView

extension RMSearchResultsView: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locationCellViewModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: RMLocationTableViewCell.cellIdentifier,
      for: indexPath
    ) as? RMLocationTableViewCell else { fatalError("Failed to dequeue RMLocationTableViewCell") }

    cell.configure(with: locationCellViewModels[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
  }

}

//MARK: - CollectionView

extension RMSearchResultsView:
  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionViewCellVM.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let currentViewModel = collectionViewCellVM[indexPath.row]
    // Character cell
    if let characterVM = currentViewModel as? RMCharacterCollectionViewCellVM {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as? RMCharacterCollectionViewCell else { fatalError() }
      cell.configure(with: characterVM)
      return cell
    } else {
      // Episode cell
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as? RMCharacterEpisodeCollectionViewCell else { fatalError() }
      if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellVM {
        cell.configure(with: episodeVM)
      }
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let currentViewModel = collectionViewCellVM[indexPath.row]
    let bounds = collectionView.bounds
    if currentViewModel is RMCharacterCollectionViewCellVM {
      let width = (bounds.width - 30) / 2
      return CGSize(
        width: width,
        height: width * 1.5
      )
    } else {
      let width = (bounds.width - 20)
      return CGSize(
        width: width,
        height: 100
      )
    }
  }

}
