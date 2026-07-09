//
//  HomeCoordinator.swift
//  Coordinator
//
//  Created by Ben Shutt on 22/10/2024.
//

import UIKit

class HomeCoordinator: TabCoordinator {
    weak var parent: MainCoordinator?
    let navigationController = UINavigationController()

    var rootViewController: UIViewController {
        navigationController
    }

    init(parent: MainCoordinator?) {
        self.parent = parent
        navigationController.setViewControllers(
            [makeRootViewController()],
            animated: false
        )
    }

    private func makeRootViewController() -> UIViewController {
        let viewController = HomeViewController()
        viewController.coordinator = self
        return viewController
    }

    func pushDetail() {
        let viewController = HomeDetailViewController()
        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }

    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
