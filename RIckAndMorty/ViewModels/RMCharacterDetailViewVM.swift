//
//  RMCharacterDetailViewVM.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/20/23.
//

import Foundation

final class RMCharacterDetailViewVM {
  private let character: RMCharacter

  init(character: RMCharacter) {
    self.character = character
  }

  public var title: String {
    character.name.uppercased()
  }

}
