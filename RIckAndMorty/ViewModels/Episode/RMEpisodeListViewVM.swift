//
//  RMEpisodeListViewVM.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/25/23.
//

import UIKit

/// <#Description#>
protocol RMEpisodeListViewVMDelegate: AnyObject {
  func didLoadInitialEpisodes()
  func didLoadMoreEpisodes(with newIndexPath: [IndexPath])

  func didSelectEpisode(_ episode: RMEpisode)
}

/// View Model to handle episode list view logic
final class RMEpisodeListViewVM: NSObject {

  public weak var delegate: RMEpisodeListViewVMDelegate?

  private var isLoadingMoreEpisodes = false

  private let borderColors: [UIColor] = [
    .systemRed,
    .systemBlue,
    .systemCyan,
    .systemPurple,
    .systemMint,
    .systemPink,
    .systemIndigo,
    .systemOrange,
    .systemGreen,
    .systemYellow
  ]

  private var episodes: [RMEpisode] = [] {
    didSet {
      for episode in episodes {
        let viewModel = RMCharacterEpisodeCollectionViewCellVM(
          episodeDataUrl: URL(string: episode.url),
          borderColor: borderColors.randomElement() ?? .systemBlue
        )
        if !cellViewModels.contains(viewModel) {
          cellViewModels.append(viewModel)
        }
      }
    }
  }

  private var cellViewModels: [RMCharacterEpisodeCollectionViewCellVM] = []

  private var apiInfo: RMGetAllEpisodesResponse.Info? = nil

  /// Fetch initial set of characters (20)
  func fetchEpisodes() {
    RMService.shared.execute(
      .listEpisodesRequests,
      expecting: RMGetAllEpisodesResponse.self
    ) { [weak self] result in
      switch result {
      case .success(let responseModel):
        let results = responseModel.results
        let info = responseModel.info
        self?.episodes = results
        self?.apiInfo = info
        DispatchQueue.main.async {
          self?.delegate?.didLoadInitialEpisodes()
        }

      case .failure(let error):
        print(String(describing: error))
      }
    }
  }

  /// Paginate if additional episodes are needed
  public func fetchAdditionalEpisodes(url: URL) {
    guard !isLoadingMoreEpisodes else {
      return
    }

    isLoadingMoreEpisodes = true
    guard let request = RMRequest(url: url) else {
      isLoadingMoreEpisodes = false
      return
    }

    RMService.shared.execute(
      request,
      expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
        guard let strongSelf = self else {
          return
        }
        switch result {
        case .success(let responseModel):
          let moreResults = responseModel.results
          let info = responseModel.info
          strongSelf.apiInfo = info

          let originalCount = strongSelf.episodes.count
          let newCount = moreResults.count
          let indexPathToAdd: [IndexPath] = Array(originalCount ..< (originalCount + newCount)).compactMap({
            return IndexPath(row: $0, section: 0)
          })

          strongSelf.episodes.append(contentsOf: moreResults)
          DispatchQueue.main.async {
            strongSelf.delegate?.didLoadMoreEpisodes(
              with: indexPathToAdd
            )
            strongSelf.isLoadingMoreEpisodes = false
          }
        case .failure(let failure):
          print(String(describing: failure))
          strongSelf.isLoadingMoreEpisodes = false
        }
      }
  }

  public var shouldShowLoadMoreIndicator: Bool {
    return apiInfo?.next != nil
  }

}

//MARK: - CollectionView

extension RMEpisodeListViewVM: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    cellViewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
      for: indexPath
    ) as? RMCharacterEpisodeCollectionViewCell else {
      fatalError("Unsupported cell")
    }

    cell.configure(with: cellViewModels[indexPath.row])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let bounds = collectionView.bounds
    let width = (bounds.width - 20)
    return CGSize(
      width: width,
      height: 100
    )
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let episode = episodes[indexPath.row]
    delegate?.didSelectEpisode(episode)
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionFooter,
          let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
            for: indexPath
          ) as? RMFooterLoadingCollectionReusableView
    else {
      fatalError("Unsupported")
    }
    footer.startAnimating()
    return footer
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    guard shouldShowLoadMoreIndicator else {
      return .zero
    }

    return CGSize(width: collectionView.frame.width, height: 100)
  }

}

//MARK: - ScrollView

extension RMEpisodeListViewVM {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard shouldShowLoadMoreIndicator,
          !isLoadingMoreEpisodes,
          !cellViewModels.isEmpty,
          let nextUrlString = apiInfo?.next,
          let url = URL(string: nextUrlString) else {
      return
    }

    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
      let offset = scrollView.contentOffset.y
      let totalContentHeight = scrollView.contentSize.height
      let totalScrollViewFixedHeight = scrollView.frame.size.height

      if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
        self?.fetchAdditionalEpisodes(url: url)
      }

      t.invalidate()
    }
  }

}

