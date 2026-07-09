//
//  MoreDetailViewController.swift
//  Coordinator
//
//  Created by Ben Shutt on 22/10/2024.
//

import SwiftUI

class MoreDetailViewController: ViewController {
    weak var coordinator: MoreCoordinator?

    override var screenColor: Color {
        .red.opacity(0.2)
    }

    override var screenTitle: LocalizedStringKey {
        "More Detail"
    }

    override var screenButton: Screen.Button? {
        .init(
            title: "Select Home",
            action: { [weak self] in
                self?.coordinator?.selectHome()
            }
        )
    }
}
