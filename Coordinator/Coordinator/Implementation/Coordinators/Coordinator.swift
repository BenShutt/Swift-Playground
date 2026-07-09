//
//  Coordinator.swift
//  Coordinator
//
//  Created by Ben Shutt on 22/10/2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var rootViewController: UIViewController { get }
}

// MARK: - TabCoordinator

protocol TabCoordinator: Coordinator {
    var parent: MainCoordinator? { get }
}

extension TabCoordinator {
    var tabIndex: Int? {
        parent?.tabIndex(of: self)
    }
}
