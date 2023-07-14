//
//  RMEpisode.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/13/23.
//

import Foundation

struct RMEpisode: Codable {

  /// The id of the episode.
  let id: Int
  /// The name of the episode.
  let name: String
  /// The air date of the episode.
  let air_date: String
  /// The code of the episode.
  let episode: String
  /// List of characters who have been seen in the episode.
  let characters: [String]
  /// Link to the episode's own endpoint.
  let url: String
  /// Time at which the episode was created in the database.
  let created: String

}
