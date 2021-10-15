import UIKit
import ProductHuntKit

/// A protocol that defines an object that can be used as an item identifier in a diffable data source, and provides
/// a cell provider.
protocol CellProvidable: Hashable {

  associatedtype ItemType: Hashable

  init(itemType: ItemType, cellProvider: CellProviding?)

  /// The actual hashable value used by the diffable data source.
  var itemType: ItemType { get }

  /// A cell provider creating a cell for this item.
  var cellProvider: CellProviding? { get set }

}

extension CellProvidable {

  init(itemType: ItemType) {
    self.init(itemType: itemType, cellProvider: nil)
  }

}

// MARK: - Hashable

extension CellProvidable {

  func hash(into hasher: inout Hasher) {
    itemType.hash(into: &hasher)
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.itemType == rhs.itemType
  }

}

// MARK: - Convenience Constructors

extension CellProvidable {

  static func post<Section: Hashable>(
    _ post: Post,
    itemType: ItemType,
    imageLoader: ImageLoading,
    dataSource: UITableViewDiffableDataSource<Section, Self>,
    showsHunter: Bool,
    showsDisclosure: Bool
  ) -> Self {
    var item = Self(itemType: itemType)
    let dataSourceReloader = DataSourceReloader(dataSource: dataSource, itemIdentifier: item)

    let cellProvider = PostCellProvider<Section, Self>(
      post: post,
      imageLoader: imageLoader,
      dataSourceReloader: dataSourceReloader,
      showsHunter: showsHunter,
      showsDisclosure: showsDisclosure
    )

    item.cellProvider = cellProvider
    return item
  }

  static func user<Section: Hashable>(
    _ user: User,
    itemType: ItemType,
    imageLoader: ImageLoading,
    dataSource: UITableViewDiffableDataSource<Section, Self>,
    showsDisclosure: Bool
  ) -> Self {
    var item = Self(itemType: itemType)
    let dataSourceReloader = DataSourceReloader(dataSource: dataSource, itemIdentifier: item)

    let cellProvider = UserCellProvider<Section, Self>(
      user: user,
      imageLoader: imageLoader,
      dataSourceReloader: dataSourceReloader,
      showsDisclosure: showsDisclosure
    )

    item.cellProvider = cellProvider
    return item
  }

  static func image<Section: Hashable>(
    _ url: URL,
    itemType: ItemType,
    imageLoader: ImageLoading,
    dataSource: UITableViewDiffableDataSource<Section, Self>
  ) -> Self {
    var item = Self(itemType: itemType)
    let dataSourceReloader = DataSourceReloader(dataSource: dataSource, itemIdentifier: item)

    let cellProvider = MediaCellProvider<Section, Self>(
      url: url,
      imageLoader: imageLoader,
      dataSourceReloader: dataSourceReloader
    )

    item.cellProvider = cellProvider
    return item
  }

  static func text(_ text: String, itemType: ItemType) -> Self {
    Self(itemType: itemType, cellProvider: StandardCellProvider(text: text))
  }

  static func loading(itemType: ItemType) -> Self {
    Self(itemType: itemType, cellProvider: LoadingCellProvider())
  }

}
