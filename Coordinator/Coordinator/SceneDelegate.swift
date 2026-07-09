//
//  SceneDelegate.swift
//  Coordinator
//
//  Created by Ben Shutt on 22/10/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let coordinator = MainCoordinator()
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = coordinator.rootViewController
        window?.makeKeyAndVisible()
    }
}
