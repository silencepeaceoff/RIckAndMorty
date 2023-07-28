//
//  RMCharacterDetailViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/20/23.
//

import UIKit

/// Controllet to show info about single character
final class RMCharacterDetailViewController: UIViewController {

  private let viewModel: RMCharacterDetailViewVM
  private let detailView: RMCharacterDetailView

  //MARK: - Init

  init(viewModel: RMCharacterDetailViewVM) {
    self.viewModel = viewModel
    self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  //MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
    addConstraints()
    
    detailView.collectionView?.delegate = self
    detailView.collectionView?.dataSource = self
  }

  private func setupView() {
    view.backgroundColor = .systemBackground
    title = viewModel.title
    view.addSubview(detailView)

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .action,
      target: self,
      action: #selector(didTapShare)
    )

  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  @objc
  private func didTapShare() {
    // Share character info

  }

}

//MARK: - CollectionView

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel.sections.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let sectionType = viewModel.sections[section]
    switch sectionType {
    case .photo:
      return 1
    case .information(viewModels: let viewModels):
      return viewModels.count
    case .episodes(viewModels: let viewModels):
      return viewModels.count
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let sectionType = viewModel.sections[indexPath.section]

    switch sectionType {
    case .photo(let viewModel):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifire,
        for: indexPath
      ) as? RMCharacterPhotoCollectionViewCell else {
        fatalError()
      }
      cell.configure(with: viewModel)

      return cell

    case .information(let viewModels):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifire,
        for: indexPath
      ) as? RMCharacterInfoCollectionViewCell else {
        fatalError()
      }
      cell.configure(with: viewModels[indexPath.row])

      return cell

    case .episodes(let viewModels):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifire,
        for: indexPath
      ) as? RMCharacterEpisodeCollectionViewCell else {
        fatalError()
      }
      let viewModel = viewModels[indexPath.row]
      cell.configure(with: viewModel)

      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let sectionType = viewModel.sections[indexPath.section]

    switch sectionType {
    case .photo, .information:
      break
    case .episodes:
      let episodes = self.viewModel.episodes
      let selections = episodes[indexPath.row]
      let vc = RMEpisodeDetailViewController(url: URL(string: selections))
      navigationController?.pushViewController(vc, animated: true)
    }
  }

}
