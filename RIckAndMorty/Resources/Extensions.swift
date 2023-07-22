//
//  Extensions.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/18/23.
//

import UIKit

extension UIView {

  func addSubviews(_ views: UIView...) {
    views.forEach {
      addSubview($0)
    }
  }

}
