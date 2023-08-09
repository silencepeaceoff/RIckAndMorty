//
//  RMSettingsOption.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/28/23.
//

import UIKit

enum RMSettingsOption: CaseIterable {

  case rateApp
  case contactUs
  case terms
  case privacy
  case apiReference
  case viewSeries
  case viewCode

  var targetUrl: URL? {
    switch self {
    case .rateApp:
      return nil
    case .contactUs:
      return URL(string: "https://www.linkedin.com/in/silencepeaceoff/")
    case .terms:
      return URL(string: "https://rickandmortyapi.com/about")
    case .privacy:
      return URL(string: "https://rickandmortyapi.com/about")
    case .apiReference:
      return URL(string: "https://rickandmortyapi.com/")
    case .viewSeries:
      return URL(string: "https://www.justwatch.com/us/tv-show/rick-and-morty")
    case .viewCode:
      return URL(string: "https://github.com/silencepeaceoff/RIckAndMorty")
    }
  }

  var displayTitle: String {
    switch self {
    case .rateApp:
      return "Rate App"
    case .contactUs:
      return "Contact Us"
    case .terms:
      return "Terms of Service"
    case .privacy:
      return "Privacy Policy"
    case .apiReference:
      return "API Reference"
    case .viewSeries:
      return "View Video Series"
    case .viewCode:
      return "View App Code"
    }
  }

  var iconContainerColor: UIColor {
    switch self {
    case .rateApp:
      return .systemOrange
    case .contactUs:
      return .systemBlue
    case .terms:
      return .systemGray
    case .privacy:
      return .systemPink
    case .apiReference:
      return .systemGreen
    case .viewSeries:
      return .systemIndigo
    case .viewCode:
      return .systemYellow
    }
  }

  var iconImage: UIImage? {
    switch self {
    case .rateApp:
      return UIImage(systemName: "star.fill")
    case .contactUs:
      return UIImage(systemName: "paperplane")
    case .terms:
      return UIImage(systemName: "doc")
    case .privacy:
      return UIImage(systemName: "lock")
    case .apiReference:
      return UIImage(systemName: "list.clipboard")
    case .viewSeries:
      return UIImage(systemName: "tv.fill")
    case .viewCode:
      return UIImage(systemName: "hammer.fill")
    }
  }

}
