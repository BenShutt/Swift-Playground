//
//  MoreCoordinator.swift
//  Coordinator
//
//  Created by Ben Shutt on 22/10/2024.
//

import UIKit

class MoreCoordinator: TabCoordinator {
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
        let viewController = MoreViewController()
        viewController.coordinator = self
        return viewController
    }

    func pushDetail() {
        let viewController = MoreDetailViewController()
        viewController.coordinator = self
        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }

    func selectHome() {
        parent?.selectHome()
    }
}
