import UIKit

/// A diffable data source that constructs table view cells from the cell provider of its item identifiers.
class DiffableDataSource<Section, Item>: UITableViewDiffableDataSource<Section, Item>
where Section: Hashable, Item: Hashable & CellProvidable {

  init(tableView: UITableView) {
    super.init(tableView: tableView) { tableView, indexPath, item in
      if let cell = item.cellProvider?.cell(at: indexPath, tableView: tableView) {
        return cell
      }

      return tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
    }
  }

}
