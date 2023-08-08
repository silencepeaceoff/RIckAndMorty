//
//  RMLocationViewVM.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/29/23.
//

import Foundation

protocol RMLocationViewVMDelegate: AnyObject {
  func didFetchInitialLocations()
}

final class RMLocationViewVM {

  weak var delegate: RMLocationViewVMDelegate?

  private var locations: [RMLocation] = [] {
    didSet {
      for location in locations {
        let cellViewModel = RMLocationTableViewCellVM(location: location)
        if !cellViewModels.contains(cellViewModel) {
          cellViewModels.append(cellViewModel)
        }
      }
    }
  }

  private var apiInfo: RMGetAllLocationsResponse.Info?

  private var didFinishPagination: (() -> Void?)?

  private var hasMoreResults: Bool {
    return false
  }

  public var shouldShowLoadMoreIndicator: Bool {
    return apiInfo?.next != nil
  }

  public private(set) var cellViewModels: [RMLocationTableViewCellVM] = []

  public func location(at index: Int) -> RMLocation? {
    guard index <= locations.count, index >= 0 else { return nil }
    return self.locations[index]
  }

  public var isLoadingMoreLocations = false

  //MARK: - Init

  init() {
    
  }

  public func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) {
    self.didFinishPagination = block
  }

  /// Paginate if additional location are needed
  public func fetchAdditionalLocations() {

    guard !isLoadingMoreLocations
    else { return }
    isLoadingMoreLocations = true

    guard let nextUrlString = apiInfo?.next,
          let url = URL(string: nextUrlString)
    else { return }

    guard let request = RMRequest(url: url)
    else {
      isLoadingMoreLocations = false
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
          strongSelf.apiInfo = info
          strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
            return RMLocationTableViewCellVM(location: $0)
          }))
          DispatchQueue.main.async {
            strongSelf.isLoadingMoreLocations = false
            // Notify via callback
            strongSelf.didFinishPagination?()
          }

        case .failure(let failure):
          print(String(describing: failure))
          strongSelf.isLoadingMoreLocations = false
        }
      }
  }

  public func fetchLocations() {
    RMService.shared.execute(
      .listLocationsRequests,
      expecting: RMGetAllLocationsResponse.self
    ) { [weak self] result in
      switch result {
      case .success(let model):
        self?.apiInfo = model.info
        self?.locations = model.results
        DispatchQueue.main.async {
          self?.delegate?.didFetchInitialLocations()
        }
      case .failure:
        print("Failed fetch location")
        break
      }
    }
  }

}
