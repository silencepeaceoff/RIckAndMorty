//
//  RMSearchInputView.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 8/2/23.
//

import UIKit

protocol RMSearchInputViewDelelegate: AnyObject {
  func rmSearchInputView(
    _ inputView: RMSearchInputView,
    didSelect option: RMSearchInputViewVM.DynamicOption

  )

  func rmSearchInputView(
    _ inputView: RMSearchInputView,
    didChangeSearchText text: String
  )

  func rmSearchInputViewDidTapSearchKeyboardButton(
    _ inputView: RMSearchInputView
  )
}

/// View for top part of search screen wtth search bar
final class RMSearchInputView: UIView {

  weak var delegate: RMSearchInputViewDelelegate?

  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "Search"
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    return searchBar
  }()

  private var viewModel: RMSearchInputViewVM? {
    didSet {
      guard let viewModel = viewModel,
            viewModel.hasDynamicOptions else { return }
      let options = viewModel.options
      createOptionSelectionViews(options: options)
    }
  }

  private var stackView: UIStackView?

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false

    addSubviews(searchBar)
    addConstraints()

    searchBar.delegate = self
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  //MARK: - Private

  private func addConstraints() {
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: topAnchor),
      searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
      searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
      searchBar.heightAnchor.constraint(equalToConstant: 58)
    ])
  }

  private func createOptionStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.spacing = 6
    stackView.distribution = .fillEqually
    stackView.alignment = .center

    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])

    return stackView
  }

  private func createOptionSelectionViews(options: [RMSearchInputViewVM.DynamicOption]) {
    let stackView = createOptionStackView()
    self.stackView = stackView
    for x in 0 ..< options.count {
      let option = options[x]
      let button = createButton(with: option, tag: x)
      stackView.addArrangedSubview(button)
    }
  }

  private func createButton(with option: RMSearchInputViewVM.DynamicOption, tag: Int) -> UIButton {
    let button = UIButton()
    button.setAttributedTitle(
      NSAttributedString(
        string: option.rawValue,
        attributes: [
          .font: UIFont.systemFont(ofSize: 18, weight: .medium),
          .foregroundColor: UIColor.label
        ]
      ),
      for: .normal
    )
    button.backgroundColor = .secondarySystemBackground
    button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    button.tag = tag
    button.layer.cornerRadius = 6

    return button
  }

  @objc
  private func didTapButton(_ sender: UIButton) {
    guard let options = viewModel?.options else { return }
    let tag = sender.tag
    let selected = options[tag]
    delegate?.rmSearchInputView(self, didSelect: selected)
  }

  //MARK: - Public

  public func configure(with viewModel: RMSearchInputViewVM) {
    searchBar.placeholder = viewModel.searchPlaceholderText
    self.viewModel = viewModel
  }

  public func presentKeyboard() {
    searchBar.becomeFirstResponder()
  }

  public func update(option: RMSearchInputViewVM.DynamicOption, value: String) {
    // Update options
    guard let buttons = stackView?.arrangedSubviews as? [UIButton],
          let allOptions = viewModel?.options,
          let index = allOptions.firstIndex(of: option) else { return }

    buttons[index].setAttributedTitle(
      NSAttributedString(
        string: value.uppercased(),
        attributes: [
          .font: UIFont.systemFont(ofSize: 18, weight: .medium),
          .foregroundColor: UIColor.link
        ]
      ),
      for: .normal
    )
    
  }

}

//MARK: - UISearchBarDelegate

extension RMSearchInputView: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // Notify changing text
    delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    // Notify that search button tapped
    searchBar.resignFirstResponder()
    delegate?.rmSearchInputViewDidTapSearchKeyboardButton(self)
  }
}
