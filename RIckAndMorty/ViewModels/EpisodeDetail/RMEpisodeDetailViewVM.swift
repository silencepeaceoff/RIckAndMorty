//
//  RMEpisodeDetailViewVM.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/25/23.
//

import UIKit

protocol RMEpisodeDetailViewVMDelegate: AnyObject {
  func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewVM {

  private let endpointUrl: URL?

  private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
    didSet {
      createCellViewModels()
      delegate?.didFetchEpisodeDetails()
    }
  }

  enum SectionType {
    case information(viewModel: [RMEpisodeInfoCollectionViewCellVM])
    case characters(viewModel: [RMCharacterCollectionViewCellVM])
  }

  public private(set) var cellViewModels: [SectionType] = []

  public weak var delegate: RMEpisodeDetailViewVMDelegate?

  //MARK: - Init

  init(endpointUrl: URL?) {
    self.endpointUrl = endpointUrl
  }

  //MARK: - Public

  public func character(at index: Int) -> RMCharacter? {
    guard let dataTuple = dataTuple else { return nil }
    return dataTuple.characters[index]
  }

  /// Fetch backing episode model
  public func fetchEpisodeData() {
    guard let url = endpointUrl,
          let request = RMRequest(url: url) else {
      return
    }

    RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
      switch result {
      case .success(let model):
        self?.fetchRelatedCharacters(episode: model)
      case .failure:
        break
      }
    }
  }

  //MARK: - Private

  private func createCellViewModels() {
    guard let dataTuple = dataTuple else { return }

    let episode = dataTuple.episode
    let characters = dataTuple.characters

    var createdString = ""
    if let date = RMCharacterInfoCollectionViewCellVM.dateFormatter.date(from: episode.created) {
      createdString = RMCharacterInfoCollectionViewCellVM.shortDateFormatter.string(from: date) 
    }

    cellViewModels = [
      .information(viewModel: [
        .init(title: "Episode Name", value: episode.name),
        .init(title: "Air Date", value: episode.air_date),
        .init(title: "Episode", value: episode.episode),
        .init(title: "Created", value: createdString)
      ]),
      .characters(viewModel: characters.compactMap {
        return RMCharacterCollectionViewCellVM(
          characterName: $0.name,
          characterStatus: $0.status,
          characterImageUrl: URL(string: $0.image)
        )
      })
    ]
  }

  private func fetchRelatedCharacters(episode: RMEpisode) {
    let requests = episode.characters.compactMap {
      return URL(string: $0)
    }.compactMap {
      return RMRequest(url: $0)
    }

    let group = DispatchGroup()
    var characters: [RMCharacter] = []
    for request in requests {
      group.enter()
      RMService.shared.execute(
        request,
        expecting: RMCharacter.self) { result in
          defer {
            group.leave()
          }

          switch result {
          case .success(let model):
            characters.append(model)
          case .failure:
            break
          }
        }
    }
    group.notify(queue: .main) {
      self.dataTuple = (
        episode: episode, characters: characters
      )
    }
  }

}
