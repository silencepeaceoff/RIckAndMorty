//
//  RMSearchResultVM.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 8/6/23.
//

import Foundation

final class RMSearchResultVM {

  public private(set) var results: RMSearchResultType
  private var next: String?

  //MARK: - Init

  init(results: RMSearchResultType, next: String?) {
    self.results = results
    self.next = next
  }

  public private(set) var isLoadingMoreResults = false

  public var shouldShowLoadMoreIndicator: Bool {
    return next != nil
  }

  public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellVM]) -> Void) {

    guard !isLoadingMoreResults
    else { return }
    isLoadingMoreResults = true

    guard let nextUrlString = next,
          let url = URL(string: nextUrlString)
    else { return }

    guard let request = RMRequest(url: url)
    else {
      isLoadingMoreResults = false
      return
    }

    RMService.shared.execute(
      request,
      expecting: RMGetAllLocationsResponse.self) { [weak self] result in
        guard let strongSelf = self else { return }
        switch result {
        case .success(let responseModel):
          let moreResults = responseModel.results
          let info = responseModel.info
          strongSelf.next = info.next // Capture new pagination url

          let additionalLocations = moreResults.compactMap({
            return RMLocationTableViewCellVM(location: $0)
          })
          var newResults: [RMLocationTableViewCellVM] = []
          switch strongSelf.results {
          case .locations(let existingResults):
            newResults = existingResults + additionalLocations
            strongSelf.results = .locations(newResults)

          case .characters, .episodes:
            break
          }

          DispatchQueue.main.async {
            strongSelf.isLoadingMoreResults = false
            // Notify via callback
            completion(newResults)
          }

        case .failure(let failure):
          print(String(describing: failure))
          strongSelf.isLoadingMoreResults = false
        }
      }
  }

  public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
    guard !isLoadingMoreResults
    else { return }
    isLoadingMoreResults = true

    guard let nextUrlString = next,
          let url = URL(string: nextUrlString)
    else { return }

    guard let request = RMRequest(url: url)
    else {
      isLoadingMoreResults = false
      return
    }

    switch results {
    case .characters(let existingResults):
      RMService.shared.execute(
        request,
        expecting: RMGetAllCharactersResponse.self) { [weak self] result in
          guard let strongSelf = self else { return }
          switch result {
          case .success(let responseModel):
            let moreResults = responseModel.results
            let info = responseModel.info
            strongSelf.next = info.next // Capture new pagination url

            let additionalResults = moreResults.compactMap({
              return RMCharacterCollectionViewCellVM(
                characterName: $0.name,
                characterStatus: $0.status,
                characterImageUrl: URL(string: $0.image))
            })

            var newResults: [RMCharacterCollectionViewCellVM] = []
            newResults = existingResults + additionalResults
            strongSelf.results = .characters(newResults)

            DispatchQueue.main.async {
              strongSelf.isLoadingMoreResults = false
              // Notify via callback
              completion(newResults)
            }

          case .failure(let failure):
            print(String(describing: failure))
            strongSelf.isLoadingMoreResults = false
          }
        }
    case .episodes(let existingResults):
      RMService.shared.execute(
        request,
        expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
          guard let strongSelf = self else { return }
          switch result {
          case .success(let responseModel):
            let moreResults = responseModel.results
            let info = responseModel.info
            strongSelf.next = info.next // Capture new pagination url

            let additionalResults = moreResults.compactMap({
              return RMCharacterEpisodeCollectionViewCellVM(
                episodeDataUrl: URL(string: $0.url))
            })

            var newResults: [RMCharacterEpisodeCollectionViewCellVM] = []
            newResults = existingResults + additionalResults
            strongSelf.results = .episodes(newResults)

            DispatchQueue.main.async {
              strongSelf.isLoadingMoreResults = false
              // Notify via callback
              completion(newResults)
            }

          case .failure(let failure):
            print(String(describing: failure))
            strongSelf.isLoadingMoreResults = false
          }
        }
    case .locations:
      // TableView case
      break
    }


  }

}

enum RMSearchResultType {
  case characters([RMCharacterCollectionViewCellVM])
  case locations([RMLocationTableViewCellVM])
  case episodes([RMCharacterEpisodeCollectionViewCellVM])
}
