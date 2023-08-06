//
//  RMSearchView.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 8/2/23.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
  func rmSearchView(
    _ searchView: RMSearchView,
    didSelectOption option: RMSearchInputViewVM.DynamicOption
  )
}

final class RMSearchView: UIView {

  weak var delegate: RMSearchViewDelegate?

  private let viewModel: RMSearchViewVM

  //MARK: - Subviews

  // SearchInputView(bar, selection buttons)
  private let searchInputView = RMSearchInputView()
  // No results view
  private let noResultsView = RMNoSearchResultsView()
  // Results collectionView

  //MARK: - Init

  init(frame: CGRect, viewModel: RMSearchViewVM) {
    self.viewModel = viewModel
    super.init(frame: frame)

    backgroundColor = .systemBackground
    translatesAutoresizingMaskIntoConstraints = false

    addSubviews(noResultsView, searchInputView)
    addConstraints()

    searchInputView.configure(with: RMSearchInputViewVM(type: viewModel.config.type))
    searchInputView.delegate = self

    viewModel.registerOptionChangeBlock { tuple in
      self.searchInputView.update(option: tuple.0, value: tuple.1)
    }

    viewModel.registerSearchResultHandler { results in
      print(results)
    }

  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      searchInputView.topAnchor.constraint(equalTo: topAnchor),
      searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
      searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
      searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),


      noResultsView.widthAnchor.constraint(equalToConstant: 150),
      noResultsView.heightAnchor.constraint(equalToConstant: 150),
      noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
      noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  public func presentKeyboard() {
    searchInputView.presentKeyboard()
  }

}

//MARK: - CollectionView

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }

}

//MARK: - RMSearchInputViewDelelegate

extension RMSearchView: RMSearchInputViewDelelegate {
  func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
    viewModel.executeSearch()
  }

  func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
    viewModel.set(query: text)
  }

  func rmSearchInputView(_ inputView: RMSearchInputView, didSelect option: RMSearchInputViewVM.DynamicOption) {
    delegate?.rmSearchView(self, didSelectOption: option)
  }
}
