//
//  RMSearchResultsView.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 8/7/23.
//

import UIKit

/// Shows search results UI (table or collection as needed)
final class RMSearchResultsView: UIView {

  private var viewModel: RMSearchResultVM? {
    didSet {
      self.processViewModel()
    }
  }

  private let tableView: UITableView = {
    let table = UITableView()
    table.register(
      RMLocationTableViewCell.self,
      forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier
    )
    table.isHidden = true
    table.translatesAutoresizingMaskIntoConstraints = false
    return table
  }()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    isHidden = true
    addSubview(tableView)
    addConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
    tableView.backgroundColor = .systemYellow
  }

  private func processViewModel() {
    guard let viewModel = viewModel else { return }
    switch viewModel {
    case .characters(let viewModels):
      setupCollectionView()
    case .episodes(let viewModels):
      setupCollectionView()
    case .locations(let viewModels):
      setupTableView()
    }
  }

  private func setupCollectionView() {

  }

  private func setupTableView() {
    tableView.isHidden = false
  }

  public func configure(with viewModel: RMSearchResultVM) {
    self.viewModel = viewModel
  }

}
