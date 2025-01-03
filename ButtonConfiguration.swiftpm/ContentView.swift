import SwiftUI

struct ContentView: UIViewRepresentable {
  func makeUIView(context: Context) -> ScreenView {
    ScreenView()
  }
  func updateUIView(_ uiView: ScreenView, context: Context) {
    // do nothing
  }
}

// MARK: - ScreenView

class ScreenView: UIView {
  private let button = CustomButtonView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("\(#function) has not been implemented")
  }

  private func setup() {
    addSubview(button)
    button.constrainCenter(to: self)
  }
}

// MARK: - CustomButtonView

/// Needed so we can perform custom animation on the background
class CustomButtonView: UIView {
  private lazy var button = makeButton()
  private lazy var buttonBackgroundView = {
    let view = UIView()
    view.backgroundColor = .systemBlue
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("\(#function) has not been implemented")
  }

  private func setup() {
    addSubview(buttonBackgroundView)
    addSubview(button)
    button.sizeToFit()

    var edges = button.constrainEdges(to: buttonBackgroundView)
    edges.insets = .init(top: 5, left: 10, bottom: 5, right: 10)
    buttonBackgroundView.constrainEdges(to: self)
  }

  private func makeButton() -> UIButton {
    var configuration = UIButton.Configuration.plain()
    configuration.baseForegroundColor = .white
    configuration.title = "TAP ME"

    return UIButton(
      configuration: configuration,
      primaryAction: UIAction(handler: { [weak self] _ in
        self?.animateButtonBackground()
      }))
  }

  private func animateButtonBackground() {
    animateButtonBackgroundView(
      transform: .init(scaleX: 1.5, y: 1.5),
      options: [.curveEaseOut],
      completion: { _ in
        self.animateButtonBackgroundView(
          transform: .identity,
          options: [.curveEaseIn]
        )
      }
    )
  }
  
  private func animateButtonBackgroundView(
    transform: CGAffineTransform,
    options:  UIView.AnimationOptions,
    completion: ((Bool) -> Void)? = nil
  ) {
    UIView.animate(
      withDuration: 0.1,
      delay: 0,
      options: options,
      animations: {
        self.buttonBackgroundView.transform = transform
      },
      completion: completion
    )
  }
}
