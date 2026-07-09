//
//  HomeDetailViewController.swift
//  Coordinator
//
//  Created by Ben Shutt on 22/10/2024.
//

import SwiftUI

class HomeDetailViewController: ViewController {
    override var screenColor: Color {
        .green.opacity(0.2)
    }

    override var screenTitle: LocalizedStringKey {
        "Home Detail"
    }

    override var screenButton: Screen.Button? {
        nil
    }
}
