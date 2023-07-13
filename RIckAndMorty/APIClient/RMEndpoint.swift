//
//  RMEndPoint.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/13/23.
//

import Foundation

/// REpresents unique API endpoint
enum RMEndpoint: String {
  /// Endpoint to get character info
  case character
  /// Endpoint to get location info
  case location
  /// Endpoint to get episode info
  case episode
}
