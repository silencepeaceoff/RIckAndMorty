//
//  RMGetAllCharactersResponse.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/15/23.
//

import Foundation

struct RMGetAllCharactersResponse: Codable {

  struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
  }

  let info: Info
  let results: [RMCharacter]

}
