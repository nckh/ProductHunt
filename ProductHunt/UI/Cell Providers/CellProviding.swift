import UIKit

/// A protocol that defines methods to create a cell and update its configuration.
protocol CellProviding {

  func customize(_ cell: UITableViewCell)
  func update(_ contentConfiguration: inout UIListContentConfiguration)

  static var reuseIdentifier: String { get }
  static var cellClass: AnyClass { get }

}

extension CellProviding {

  func cell(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)
    var contentConfiguration = cell.defaultContentConfiguration()
    update(&contentConfiguration)
    cell.contentConfiguration = contentConfiguration
    customize(cell)
    return cell
  }

  func customize(_ cell: UITableViewCell) {}
  func update(_ contentConfiguration: inout UIListContentConfiguration) {}

  static var cellClass: AnyClass { UITableViewCell.self }

}
