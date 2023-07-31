//
//  RMLocationTableViewCellVM.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/30/23.
//

import Foundation

struct RMLocationTableViewCellVM: Hashable, Equatable {

  private let location: RMLocation

  //MARK: - Init

  init(location: RMLocation) {
    self.location = location
  }

  public var name: String {
    return location.name
  }

  public var type: String {
    return "Type: " + location.type
  }

  public var dimension: String {
    return location.dimension
  }

  //MARK: - Hashable & Equatable

  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(type)
    hasher.combine(dimension)
    hasher.combine(location.id)
  }

  static func == (lhs: RMLocationTableViewCellVM, rhs: RMLocationTableViewCellVM) -> Bool {
    lhs.hashValue == rhs.hashValue
  }

}
