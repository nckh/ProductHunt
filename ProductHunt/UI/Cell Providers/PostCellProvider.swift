import UIKit
import ProductHuntKit

struct PostCellProvider<Section: Hashable, Item: Hashable>: CellProviding, CellImageLoading {

  let imageLoader: ImageLoading
  let dataSourceReloader: DataSourceReloader<Section, Item>

  private let post: Post
  private let showsHunter: Bool
  private let showsDisclosure: Bool

  init(
    post: Post,
    imageLoader: ImageLoading,
    dataSourceReloader: DataSourceReloader<Section, Item>,
    showsHunter: Bool,
    showsDisclosure: Bool
  ) {
    self.post = post
    self.imageLoader = imageLoader
    self.dataSourceReloader = dataSourceReloader
    self.showsHunter = showsHunter
    self.showsDisclosure = showsDisclosure
  }

  func customize(_ cell: UITableViewCell) {
    cell.accessoryType = showsDisclosure ? .disclosureIndicator : .none
  }

  func update(_ contentConfiguration: inout UIListContentConfiguration) {
    contentConfiguration.text = "\(post.name) (\(post.votesCount))"

    var secondaryText = "\(post.tagline)"

    if showsHunter {
      secondaryText += "\n"
      secondaryText += String(localized: "Hunted by \(post.user.name)", comment: "Hunted by XXX")
    }

    contentConfiguration.secondaryText = secondaryText
    setImage(at: post.thumbnail.url, to: &contentConfiguration)
  }

  static var reuseIdentifier: String { "Post" }
  static var imageSize: CGSize { CGSize(width: 64, height: 64) }

}
