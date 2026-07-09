//
//  HomeViewController.swift
//  Coordinator
//
//  Created by Ben Shutt on 22/10/2024.
//

import SwiftUI

class HomeViewController: ViewController {
    weak var coordinator: HomeCoordinator?

    override var screenColor: Color {
        .orange.opacity(0.2)
    }

    override var screenTitle: LocalizedStringKey {
        "Home"
    }

    override var screenButton: Screen.Button? {
        .init(
            title: "Push Home Detail",
            action: { [weak self] in
                self?.coordinator?.pushDetail()
            }
        )
    }

    override init() {
        super.init()
        tabBarItem = .init(
            title: "Home",
            image: .init(systemName: "house.fill"),
            tag: Tab.home.rawValue
        )
    }
}
