//
//  RMNoSearchResultsView.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 8/2/23.
//

import UIKit

final class RMNoSearchResultsView: UIView {

  private let viewModel = RMNoSearchResultsViewVM()

  private let iconView: UIImageView = {
    let iconView = UIImageView()
    iconView.translatesAutoresizingMaskIntoConstraints = false
    iconView.contentMode = .scaleAspectFit
    iconView.tintColor = .systemBlue
    return iconView
  }()

  private let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 20, weight: .medium)
    return label
  }()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    isHidden = true
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews(iconView, label)
    addConstraints()
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      iconView.widthAnchor.constraint(equalToConstant: 90),
      iconView.heightAnchor.constraint(equalToConstant: 90),
      iconView.topAnchor.constraint(equalTo: topAnchor),
      iconView.centerXAnchor.constraint(equalTo: centerXAnchor),

      label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10),
      label.leadingAnchor.constraint(equalTo: leadingAnchor),
      label.trailingAnchor.constraint(equalTo: trailingAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func configure() {
    label.text = viewModel.title
    iconView.image = viewModel.image
  }

}
