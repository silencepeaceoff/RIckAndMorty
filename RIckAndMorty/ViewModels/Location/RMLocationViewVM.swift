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

  private var hasMoreResults: Bool {
    return false
  }

  public private(set) var cellViewModels: [RMLocationTableViewCellVM] = []

  public func location(at index: Int) -> RMLocation? {
    guard index <= locations.count, index >= 0 else { return nil }
    return self.locations[index]
  }

  //MARK: - Init

  init() {
    
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
        break
      }
    }
  }

}
