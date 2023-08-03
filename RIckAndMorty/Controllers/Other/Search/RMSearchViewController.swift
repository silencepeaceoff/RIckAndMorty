//
//  RMSearchViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/26/23.
//

import UIKit

// Dynamic search option view
// Render results
// Render no results zero state
// Searching / API Call

/// Configurable controller to search
final class RMSearchViewController: UIViewController {

  /// Configuration for search session
  struct Config {
    enum `Type` {
      case character // name | status | gender
      case episode // name
      case location // name | type

      var title: String {
        switch self {
        case .character:
          return "Search Characters"
        case .location:
          return "Search Location"
        case .episode:
          return "Search Episode"

        }
      }
    }

    let type: `Type`
  }

  private let viewModel: RMSearchViewVM
  private let searchView: RMSearchView

  //MARK: - Init

  init(config: Config) {
    let viewModel = RMSearchViewVM(config: config)
    self.viewModel = viewModel
    self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  //MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Search",
      style: .done,
      target: self,
      action: #selector(didTapExecuteSearch)
    )
    searchView.delegate = self
    title = viewModel.config.type.title
    view.backgroundColor = .systemBackground
    view.addSubview(searchView)
    addConstraints()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchView.presentKeyboard()
  }

  @objc
  private func didTapExecuteSearch() {
//    viewModel.executeSearch()
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }

}

//MARK: - RMSearchViewDelegate

extension RMSearchViewController: RMSearchViewDelegate {
  func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewVM.DynamicOption) {
    let vc = RMSearchOptionPickerViewController(option: option) { selection in
      print("Did select \(selection)")
    }
    vc.sheetPresentationController?.detents = [.medium()]
    vc.sheetPresentationController?.prefersGrabberVisible = true
    present(vc, animated: true)
  }
}
