import UIKit

/// An object that reload a single item identifier in a diffable data source.
struct DataSourceReloader<Section: Hashable, Item: Hashable> {

  var dataSource: UITableViewDiffableDataSource<Section, Item>
  let itemIdentifier: Item

  init(dataSource: UITableViewDiffableDataSource<Section, Item>, itemIdentifier: Item) {
    self.dataSource = dataSource
    self.itemIdentifier = itemIdentifier
  }

  func reconfigureItem() {
    var snapshot = dataSource.snapshot()
    snapshot.reconfigureItems([itemIdentifier])
    dataSource.apply(snapshot, animatingDifferences: false)
  }

}
