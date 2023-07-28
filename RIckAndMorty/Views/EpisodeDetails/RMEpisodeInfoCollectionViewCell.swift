//
//  RMEpisodeInfoCollectionViewCell.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/27/23.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {

  static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"

  private let titleLable: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let valueLable: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .regular)
    label.textAlignment = .right
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.backgroundColor = .secondarySystemBackground
    contentView.addSubviews(titleLable, valueLable)
    setupLayer()
    addConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  private func setupLayer() {
    layer.cornerRadius = 8
    layer.masksToBounds = true
    layer.borderWidth = 1
    layer.borderColor = UIColor.secondaryLabel.cgColor
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      titleLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      titleLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),

      valueLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      valueLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

      titleLable.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.48),
      valueLable.widthAnchor.constraint(equalTo: titleLable.widthAnchor)
    ])
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    titleLable.text = nil
    valueLable.text = nil
  }

  func configure(with viewModel: RMEpisodeInfoCollectionViewCellVM) {
    titleLable.text = viewModel.title
    valueLable.text = viewModel.value
  }

}
