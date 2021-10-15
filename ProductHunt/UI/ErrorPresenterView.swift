import UIKit

protocol ErrorPresenterView {

  func presentError(message: String, retryHandler: (() -> Void)?)

}

extension ErrorPresenterView where Self: UIViewController {

  func presentError(message: String, retryHandler: (() -> Void)?) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let retryTitle = String(localized: "Retry", comment: "Retry button in error alert")
    let cancelTitle = String(localized: "Cancel", comment: "Cancel button in error alert")
    let retryAction = UIAlertAction(title: retryTitle, style: .default) { _ in retryHandler?() }
    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
    alert.addAction(retryAction)
    alert.addAction(cancelAction)
    present(alert, animated: true)
  }

}
