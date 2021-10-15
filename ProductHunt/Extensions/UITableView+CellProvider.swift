import UIKit

extension UITableView {

  func register<T: CellProviding>(_ cellProvider: T.Type) {
    register(T.cellClass, forCellReuseIdentifier: T.reuseIdentifier)
  }

}
