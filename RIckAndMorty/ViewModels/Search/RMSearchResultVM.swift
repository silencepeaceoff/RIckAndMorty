//
//  RMSearchResultVM.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 8/6/23.
//

import Foundation

enum RMSearchResultVM {
  case characters([RMCharacterCollectionViewCellVM])
  case episodes([RMCharacterEpisodeCollectionViewCellVM])
  case locations([RMLocationTableViewCellVM])
}
