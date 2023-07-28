//
//  RMGetAllEpisodesResponse.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/25/23.
//

import Foundation

import Foundation

struct RMGetAllEpisodesResponse: Codable {

  struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
  }

  let info: Info
  let results: [RMEpisode]

}
