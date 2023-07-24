//
//  RMCharacterPhotoCollectionViewCellVM.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/23/23.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellVM {

  private let imageUrl: URL?

  init(imageUrl: URL?) {
    self.imageUrl = imageUrl
  }

  public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
    guard let imageUrl = imageUrl else {
      completion(.failure(URLError(.badURL)))
      return
    }
    RMImageLoader.shared.downloadImage(imageUrl, completion: completion)
  }

}
