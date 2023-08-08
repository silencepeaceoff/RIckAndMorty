//
//  RMTableLoadingFooterView.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 8/8/23.
//

import UIKit

final class RMTableLoadingFooterView: UIView {

  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.hidesWhenStopped = true
    return spinner
  }()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubviews(spinner)
    spinner.startAnimating()
    addConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      spinner.widthAnchor.constraint(equalToConstant: 55),
      spinner.heightAnchor.constraint(equalToConstant: 55),
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

}
