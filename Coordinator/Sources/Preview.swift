//
//  Preview.swift
//  Coordinator
//
//  Created by Ben Shutt on 22/10/2024.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

/// Hosts the coordinator-driven UIKit hierarchy in a SwiftUI preview,
/// standing in for the app shell that would otherwise set
/// `MainCoordinator().rootViewController` as the window root.
private struct CoordinatorPreview: UIViewControllerRepresentable {
    // Need a strong reference to prevent deallocation
    private let coordinator = MainCoordinator()

    func makeUIViewController(context: Context) -> UIViewController {
      coordinator.rootViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    CoordinatorPreview()
        .ignoresSafeArea()
}
#endif
