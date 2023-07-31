//
//  RMLocationView.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/29/23.
//

import UIKit

protocol RMLocationViewDelegate: AnyObject {
  func rmLocationView(
    _ locationView: RMLocationView,
    didSelect location: RMLocation
  )
}

final class RMLocationView: UIView {

  public weak var delegate: RMLocationViewDelegate?

  private var viewModel: RMLocationViewVM? {
    didSet {
      spinner.stopAnimating()
      tableView.isHidden = false
      tableView.reloadData()
      UIView.animate(withDuration: 0.4) {
        self.tableView.alpha = 1
      }
    }
  }

  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.hidesWhenStopped = true
    return spinner
  }()

  private var tableView: UITableView = {
    let table = UITableView(frame: .zero, style: .grouped)
    table.translatesAutoresizingMaskIntoConstraints = false
    table.isHidden = true
    table.alpha = 0
    table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
    return table
  }()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupView()
    addConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  private func setupView() {
    backgroundColor = .systemBackground
    translatesAutoresizingMaskIntoConstraints = false

    addSubviews(tableView, spinner)
    spinner.startAnimating()
    configureTable()
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      spinner.heightAnchor.constraint(equalToConstant: 100),
      spinner.widthAnchor.constraint(equalTo: spinner.heightAnchor),
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func configureTable() {
    tableView.delegate = self
    tableView.dataSource = self
  }

  public func configure(with viewModel: RMLocationViewVM) {
    self.viewModel = viewModel
  }

}

extension RMLocationView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let locationModel = viewModel?.location(at: indexPath.row) else { return }
    delegate?.rmLocationView(self, didSelect: locationModel)
  }
}

extension RMLocationView: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.cellViewModels.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cellViewModels = viewModel?.cellViewModels else { fatalError() }
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: RMLocationTableViewCell.cellIdentifier,
      for: indexPath
    ) as? RMLocationTableViewCell else { fatalError() }
    let cellViewModel = cellViewModels[indexPath.row]
    cell.configure(with: cellViewModel)
    return cell
  }

}
