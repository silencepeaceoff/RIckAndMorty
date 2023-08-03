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

  //MARK: - Init

  init(config: RMSearchViewController.Config) {
    self.config = config
  }

  //MARK: - Public

  public func set(value: String, for option: RMSearchInputViewVM.DynamicOption) {
    
  }

}
