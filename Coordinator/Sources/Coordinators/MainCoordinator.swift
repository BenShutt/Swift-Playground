//
//  MainCoordinator.swift
//  Coordinator
//
//  Created by Ben Shutt on 22/10/2024.
//

import UIKit

class MainCoordinator: Coordinator {
    lazy var homeCoordinator = HomeCoordinator(parent: self)
    lazy var moreCoordinator = MoreCoordinator(parent: self)

    let tabBarController = UITabBarController()

    var rootViewController: UIViewController {
        tabBarController
    }

    init() {
        tabBarController.setViewControllers(
            Tab.allCases.map { coordinator(for: $0).rootViewController },
            animated: false)
    }

    func coordinator(for tab: Tab) -> TabCoordinator {
        switch tab {
        case .home: homeCoordinator
        case .more: moreCoordinator
        }
    }

    func tabIndex(of coordinator: Coordinator) -> Int? {
        Tab.allCases.firstIndex {
            self.coordinator(for: $0) === coordinator
        }
    }

    func selectHome() {
        guard let index = tabIndex(of: homeCoordinator) else { return }
        tabBarController.selectedIndex = index
        homeCoordinator.popToRoot()
    }
}
