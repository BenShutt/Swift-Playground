//
//  UIView+CenterConstraints.swift
//  ButtonConfiguration
//
//  Created by Ben Shutt on 02/12/2024.
//

import UIKit

@MainActor
struct CenterConstraints {
  let centerXConstraint: NSLayoutConstraint
  let centerYConstraint: NSLayoutConstraint

  var constraints: [NSLayoutConstraint] {
    [centerXConstraint, centerYConstraint]
  }
}

// MARK: - UIView + EdgeConstraints

extension UIView {
  func centerConstraints(to view: UIView) -> CenterConstraints {
    CenterConstraints(
      centerXConstraint: centerXAnchor.constraint(equalTo: view.centerXAnchor),
      centerYConstraint: centerYAnchor.constraint(equalTo: view.centerYAnchor)
    )
  }

  @discardableResult
  func constrainCenter(to view: UIView) -> CenterConstraints {
    translatesAutoresizingMaskIntoConstraints = false
    let center = centerConstraints(to: view)
    NSLayoutConstraint.activate(center.constraints)
    return center
  }
}
