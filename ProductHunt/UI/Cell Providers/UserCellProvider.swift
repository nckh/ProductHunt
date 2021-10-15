import UIKit
import ProductHuntKit

struct UserCellProvider<Section: Hashable, Item: Hashable>: CellProviding, CellImageLoading {

  let imageLoader: ImageLoading
  let dataSourceReloader: DataSourceReloader<Section, Item>

  private let user: User
  private let showsDisclosure: Bool

  init(
    user: User,
    imageLoader: ImageLoading,
    dataSourceReloader: DataSourceReloader<Section, Item>,
    showsDisclosure: Bool
  ) {
    self.user = user
    self.imageLoader = imageLoader
    self.dataSourceReloader = dataSourceReloader
    self.showsDisclosure = showsDisclosure
  }

  func customize(_ cell: UITableViewCell) {
    cell.accessoryType = showsDisclosure ? .disclosureIndicator : .none
  }

  func update(_ contentConfiguration: inout UIListContentConfiguration) {
    contentConfiguration.text = user.name
    contentConfiguration.secondaryText = "@\(user.username)"

    setImage(at: user.profileImage, to: &contentConfiguration)
  }

  static var reuseIdentifier: String { "User" }
  static var imageSize: CGSize { CGSize(width: 32, height: 32) }

}
