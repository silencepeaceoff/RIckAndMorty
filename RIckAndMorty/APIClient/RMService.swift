//
//  RMService.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/13/23.
//

import Foundation

/// Primary API service object to get data
final class RMService {
  /// Shared singleton instance
  static let shared = RMService()

  /// Privatezed constructor
  private init() {

  }

  /// Send Rick and Morty API Call
  /// - Parameters:
  ///   - request: Request instance
  ///   - completion: Callback with data or error
  public func execute(_ request: RMRequest, completion: @escaping () -> Void) {

  }
}
