//
//  RMCharacterPhotoCollectionViewCell.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/23/23.
//

import UIKit

class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {

  static let cellIdentifire = "RMCharacterPhotoCollectionViewCell"

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(imageView)
    addConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  func addConstraints() {
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }

  public func configure(with viewModel: RMCharacterPhotoCollectionViewCellVM) {
    viewModel.fetchImage { [weak self] result in
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          self?.imageView.image = UIImage(data: data)
        }
      case .failure:
        break
      }
    }
  }

}
