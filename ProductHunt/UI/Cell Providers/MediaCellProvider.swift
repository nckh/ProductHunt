import UIKit

struct MediaCellProvider<Section: Hashable, Item: Hashable>: CellProviding, CellImageLoading {

  let imageLoader: ImageLoading
  let dataSourceReloader: DataSourceReloader<Section, Item>

  private let url: URL

  init(url: URL, imageLoader: ImageLoading, dataSourceReloader: DataSourceReloader<Section, Item>) {
    self.url = url
    self.imageLoader = imageLoader
    self.dataSourceReloader = dataSourceReloader
  }

  func update(_ contentConfiguration: inout UIListContentConfiguration) {
    setImage(at: url, to: &contentConfiguration)
  }

  static var reuseIdentifier: String { "Media" }
  static var imageSize: CGSize { CGSize(width: 512, height: 288) }

}
