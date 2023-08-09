//
//  RMSearchViewVM.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 8/2/23.
//

import Foundation

/// Responsibilities show search results, no results view, kick off API requests
final class RMSearchViewVM {

  let config: RMSearchViewController.Config

  private var searchText = ""
  private var optionMapUpdateBlock: (((RMSearchInputViewVM.DynamicOption, String)) -> Void)?
  private var optionMap: [RMSearchInputViewVM.DynamicOption: String] = [:]
  private var searchResultHandler: ((RMSearchResultVM) -> Void)?
  private var noResultsHandler: (() -> Void)?
  private var searchResultModel: Codable?

  //MARK: - Init

  init(config: RMSearchViewController.Config) {
    self.config = config
  }

  //MARK: - Public

  public func registerSearchResultHandler(_ block: @escaping (RMSearchResultVM) -> Void) {
    self.searchResultHandler = block
  }

  public func registerNoResultsHandler(_ block: @escaping () -> Void) {
    self.noResultsHandler = block
  }

  public func executeSearch() {
    guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
    // Build arguments
    var queryParams: [URLQueryItem] = [
      URLQueryItem(
        name: "name",
        value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      )
    ]

    //Add options
    queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
      let key: RMSearchInputViewVM.DynamicOption = element.key
      let value: String = element.value
      return URLQueryItem(name: key.queryArgument, value: value)
    }))

    // Create request
    let request = RMRequest(
      endpoint: config.type.endpoint,
      queryParameters: queryParams
    )

    switch  config.type.endpoint {
    case .character:
      makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
    case .episode:
      makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
    case .location:
      makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
    }
    // Notify view of results
  }

  private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
    RMService.shared.execute(request, expecting: type) { [weak self] result in
      switch result {
      case .success(let model):
        self?.processSearchResults(model: model)
      case .failure:
        self?.handleNoResults()
      }
    }
  }

  private func processSearchResults(model: Codable) {
    var resultsVM: RMSearchResultType?
    var nextUrl: String?
    if let characterResults = model as? RMGetAllCharactersResponse {
      resultsVM = .characters(characterResults.results.compactMap({
        return RMCharacterCollectionViewCellVM(
          characterName: $0.name,
          characterStatus: $0.status,
          characterImageUrl: URL(string: $0.image)
        )
      }))
      nextUrl = characterResults.info.next

    } else if let episodesResults = model as? RMGetAllEpisodesResponse {
      resultsVM = .episodes(episodesResults.results.compactMap({
        return RMCharacterEpisodeCollectionViewCellVM(episodeDataUrl: URL(string: $0.url))
      }))
      nextUrl = episodesResults.info.next

    } else if let locationsResults = model as? RMGetAllLocationsResponse {
      resultsVM = .locations(locationsResults.results.compactMap({
        return RMLocationTableViewCellVM(location: $0)
      }))
      nextUrl = locationsResults.info.next

    }

    if let results = resultsVM {
      self.searchResultModel = model
      let vm = RMSearchResultVM(results: results, next: nextUrl)
      self.searchResultHandler?(vm)
    } else {
      handleNoResults()
    }
  }

  private func handleNoResults() {
    noResultsHandler?()
  }

  public func set(query text: String) {
    self.searchText = text
  }

  public func set(value: String, for option: RMSearchInputViewVM.DynamicOption) {
    optionMap[option] = value
    let tuple = (option, value)
    optionMapUpdateBlock?(tuple)
  }

  public func registerOptionChangeBlock(
    _ block: @escaping ((RMSearchInputViewVM.DynamicOption, String)) -> Void
  ) {
    optionMapUpdateBlock = block
  }

  public func locationSearchResult(at index: Int) -> RMLocation? {
    guard let searchModel = searchResultModel as? RMGetAllLocationsResponse else { return nil }

    return searchModel.results[index]
  }

  public func characterSearchResult(at index: Int) -> RMCharacter? {
    guard let searchModel = searchResultModel as? RMGetAllCharactersResponse else { return nil }

    return searchModel.results[index]
  }

  public func episodeSearchResult(at index: Int) -> RMEpisode? {
    guard let searchModel = searchResultModel as? RMGetAllEpisodesResponse else { return nil }

    return searchModel.results[index]
  }

}
