//
//  ViewController.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/13/23.
//

import UIKit

final class RMTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .blue
    setUpTabs()
  }

  private func setUpTabs() {
    let charactersVC = RMCharactersViewController()
    let locationsVC = RMLocationsViewController()
    let episodesVC = RMEpisodesViewController()
    let settingsVC = RMSettingsViewController()

    let nav1 = UINavigationController(rootViewController: charactersVC)
    let nav2 = UINavigationController(rootViewController: locationsVC)
    let nav3 = UINavigationController(rootViewController: episodesVC)
    let nav4 = UINavigationController(rootViewController: settingsVC)

    nav1.tabBarItem = UITabBarItem(
      title: "Characters",
      image: UIImage(systemName: "person"),
      tag: 1
    )

    nav2.tabBarItem = UITabBarItem(
      title: "Locations",
      image: UIImage(systemName: "globe"),
      tag: 2
    )

    nav3.tabBarItem = UITabBarItem(
      title: "Episodes",
      image: UIImage(systemName: "tv"),
      tag: 3
    )

    nav4.tabBarItem = UITabBarItem(
      title: "Settings",
      image: UIImage(systemName: "gear"),
      tag: 4
    )

    [nav1, nav2, nav3, nav4].forEach { nav in
      nav.navigationBar.prefersLargeTitles = true
    }

    setViewControllers([
      nav1, nav2, nav3, nav4
    ], animated: true)
  }

}

