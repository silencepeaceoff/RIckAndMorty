//
//  RMCharacterCollectionViewCell.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/19/23.
//

import UIKit

/// Single cell for a character
final class RMCharacterCollectionViewCell: UICollectionViewCell {

  static let cellIndetifier = "RMCharacterCollectionViewCell"

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 18, weight: .medium)
    label.textColor = .label
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let statusLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .regular)
    label.textColor = .secondaryLabel
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  //MARK: - Init
  
  override init(frame: CGRect) {
    super .init(frame: frame)

    setupView()
    setupLayer()
    addConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    imageView.image = nil
    nameLabel.text = nil
    statusLabel.text = nil
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setupLayer()
  }

  public func configure(with viewModel: RMCharacterCollectionViewCellVM) {
    nameLabel.text = viewModel.characterName
    statusLabel.text = viewModel.characterStatusText
    viewModel.fetchImage { [weak self] result in
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          let image = UIImage(data: data)
          self?.imageView.image = image
        }
      case .failure(let error):
        print(String(describing: error))
        break
      }
    }
  }

  private func setupView() {
    contentView.backgroundColor = .secondarySystemBackground
    contentView.addSubviews(imageView, nameLabel, statusLabel)
  }

  private func setupLayer() {
    contentView.layer.cornerRadius = 8
    // Add shadow
    contentView.layer.shadowColor = UIColor.secondaryLabel.cgColor
    contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
    contentView.layer.shadowOpacity = 0.3
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      nameLabel.heightAnchor.constraint(equalToConstant: 30),
      statusLabel.heightAnchor.constraint(equalToConstant: 30),

      nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
      nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
      statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
      statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),

      statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
      nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),

      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3)
    ])
  }

}
