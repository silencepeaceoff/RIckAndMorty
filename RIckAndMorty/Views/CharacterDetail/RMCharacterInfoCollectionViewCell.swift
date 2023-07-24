//
//  RMCharacterInfoCollectionViewCell.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/23/23.
//

import UIKit

class RMCharacterInfoCollectionViewCell: UICollectionViewCell {

  static let cellIdentifire = "RMCharacterInfoCollectionViewCell"

  private let valueLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 18, weight: .light)
    return label
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 20, weight: .medium)
    return label
  }()

  private let iconImageView: UIImageView = {
    let icon = UIImageView()
    icon.translatesAutoresizingMaskIntoConstraints = false
    return icon
  }()

  private let titleContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .secondarySystemBackground
    return view
  }()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.backgroundColor = .tertiarySystemBackground
    contentView.layer.cornerRadius = 8
    contentView.clipsToBounds = true
    contentView.addSubviews(titleContainerView, valueLabel, iconImageView)
    titleContainerView.addSubview(titleLabel)
    addConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  func addConstraints() {
    NSLayoutConstraint.activate([
      titleContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      titleContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      titleContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),

      titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),

      iconImageView.heightAnchor.constraint(equalTo: titleContainerView.heightAnchor),
      iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
      iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

      valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      valueLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
      valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      valueLabel.bottomAnchor.constraint(equalTo: titleContainerView.topAnchor)
    ])
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    valueLabel.text = nil
    titleLabel.text = nil
    iconImageView.image = nil
    iconImageView.tintColor = .label
    titleLabel.textColor = .label
  }

  public func configure(with viewModel: RMCharacterInfoCollectionViewCellVM) {
    titleLabel.text = viewModel.title
    valueLabel.text = viewModel.displayValue
    iconImageView.image = viewModel.iconImage
    iconImageView.tintColor = viewModel.tintColor
    titleLabel.textColor = viewModel.tintColor
  }

}
