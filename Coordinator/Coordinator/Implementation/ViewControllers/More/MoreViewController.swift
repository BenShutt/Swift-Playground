//
//  MoreViewController.swift
//  Coordinator
//
//  Created by Ben Shutt on 22/10/2024.
//

import SwiftUI

class MoreViewController: ViewController {
    weak var coordinator: MoreCoordinator?

    override var screenColor: Color {
        .purple.opacity(0.2)
    }

    override var screenTitle: LocalizedStringKey {
        "More"
    }

    override var screenButton: Screen.Button? {
        .init(
            title: "Push More Detail",
            action: { [weak self] in
                self?.coordinator?.pushDetail()
            }
        )
    }

    override init() {
        super.init()
        tabBarItem = .init(
            title: "More",
            image: .init(systemName: "text.justify"),
            tag: Tab.more.rawValue
        )
    }
}
