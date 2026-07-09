//
//  ViewController.swift
//  Coordinator
//
//  Created by Ben Shutt on 22/10/2024.
//

import SwiftUI

// MARK: - ScreenViewController

protocol ScreenViewController {
    var screenColor: Color { get }
    var screenTitle: LocalizedStringKey { get }
    var screenButton: Screen.Button? { get }
}

extension ScreenViewController {
    var screen: Screen {
        Screen(
            color: screenColor,
            title: screenTitle,
            button: screenButton
        )
    }
}

// MARK: - ViewController

class ViewController: UIHostingController<ScreenView>, ScreenViewController {
    var screenColor: Color { fatalError("Abstract") }
    var screenTitle: LocalizedStringKey { fatalError("Abstract") }
    var screenButton: Screen.Button? { fatalError("Abstract") }

    init() {
        super.init(rootView: ScreenView())
        rootView.screen = screen
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
