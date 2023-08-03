//
//  RMSearchOptionPickerViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 8/3/23.
//

import UIKit

final class RMSearchOptionPickerViewController: UIViewController {

  private let option: RMSearchInputViewVM.DynamicOption
  private let selectionBlock: ((String) -> Void)


  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  //MARK: - Init

  init(option: RMSearchInputViewVM.DynamicOption, selection: @escaping (String) -> Void) {
    self.option = option
    self.selectionBlock = selection
    super.init(nibName: nil, bundle: nil)

  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  //MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupTable()
  }

  private func setupTable() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

}

extension RMSearchOptionPickerViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    option.choices.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let choice = option.choices[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = choice.uppercased()
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let choice = option.choices[indexPath.row]
    self.selectionBlock(choice)
    dismiss(animated: true)
  }

}
