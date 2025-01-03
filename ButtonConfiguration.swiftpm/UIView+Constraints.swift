//
//  UIView+Constraints.swift
//  ButtonConfiguration
//
//  Created by Ben Shutt on 02/12/2024.
//

import UIKit

@MainActor
struct EdgeConstraints {
  let topConstraint: NSLayoutConstraint
  let leadingConstraint: NSLayoutConstraint
  let bottomConstraint: NSLayoutConstraint
  let trailingConstraint: NSLayoutConstraint

  var constraints: [NSLayoutConstraint] {
    [
      topConstraint,
      leadingConstraint,
      bottomConstraint,
      trailingConstraint
    ]
  }

  /// - Warning: In the context of _insets_, the bottom and trailing are `* -1`
  var insets: UIEdgeInsets {
    get {
      UIEdgeInsets(
        top: top,
        left: leading,
        bottom: -bottom,
        right: -trailing
      )
    }
    set {
      top = newValue.top
      leading = newValue.left
      bottom = -newValue.bottom
      trailing = -newValue.right
    }
  }

  var top: CGFloat {
    get {
      topConstraint.constant
    } set {
      topConstraint.constant = newValue
    }
  }

  var leading: CGFloat {
    get {
      leadingConstraint.constant
    } set {
      leadingConstraint.constant = newValue
    }
  }

  var bottom: CGFloat {
    get {
      bottomConstraint.constant
    } set {
      bottomConstraint.constant = newValue
    }
  }

  var trailing: CGFloat {
    get {
      trailingConstraint.constant
    } set {
      trailingConstraint.constant = newValue
    }
  }
}

// MARK: - UIView + EdgeConstraints

extension UIView {
  func edgeConstraints(to view: UIView) -> EdgeConstraints {
    EdgeConstraints(
      topConstraint: topAnchor.constraint(equalTo: view.topAnchor),
      leadingConstraint: leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bottomConstraint: bottomAnchor.constraint(equalTo: view.bottomAnchor),
      trailingConstraint: trailingAnchor.constraint(equalTo: view.trailingAnchor)
    )
  }

  @discardableResult
  func constrainEdges(to view: UIView) -> EdgeConstraints {
    translatesAutoresizingMaskIntoConstraints = false
    let edges = edgeConstraints(to: view)
    NSLayoutConstraint.activate(edges.constraints)
    return edges
  }
}
