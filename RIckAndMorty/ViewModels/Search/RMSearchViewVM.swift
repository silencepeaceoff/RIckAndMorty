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


  //MARK: - Init

  init(config: RMSearchViewController.Config) {
    self.config = config
  }

  //MARK: - Public

  public func executeSearch() {
    // Create request
    // Send API call
    // Notify view of results
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

}
