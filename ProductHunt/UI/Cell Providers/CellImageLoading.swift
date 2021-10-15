import UIKit

/// A protocol adopted by cell providers in order to load an image asynchronously and display it in a table view cell.
protocol CellImageLoading {

  associatedtype Section: Hashable
  associatedtype Item: Hashable

  var imageLoader: ImageLoading { get }
  var dataSourceReloader: DataSourceReloader<Section, Item> { get }

  static var imageSize: CGSize { get }

}

extension CellImageLoading {

  func setImage(at url: URL, to contentConfiguration: inout UIListContentConfiguration) {
    contentConfiguration.imageProperties.maximumSize = Self.imageSize

    if let cachedImage = imageLoader.cachedImage(at: url) {
      contentConfiguration.image = cachedImage
    } else {
      contentConfiguration.image = .placeholderImage(sized: Self.imageSize, color: .systemGray6)

      imageLoader.fetchImage(at: url) { [dataSourceReloader] _ in
        DispatchQueue.main.async { [dataSourceReloader] in
          dataSourceReloader.reconfigureItem()
        }
      }
    }
  }

}
