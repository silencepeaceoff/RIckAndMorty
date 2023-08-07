//
//  RMSearchResultVM.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 8/6/23.
//

import Foundation

enum RMSearchResultVM {
  case characters([RMCharacterCollectionViewCellVM])
  case locations([RMLocationTableViewCellVM])
  case episodes([RMCharacterEpisodeCollectionViewCellVM])
}
