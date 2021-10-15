import UIKit
import OSLog

final class ImageLoader {

  private let urlSession: URLSession
  private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
  private let urlCache: URLCache

  private var logger: Logger {
    Logger(subsystem: "com.nckh.ProductHunt", category: "Image Downloading")
  }

  init(urlSession: URLSession = .shared, urlCache: URLCache = .shared) {
    self.urlSession = urlSession
    self.urlCache = urlCache
  }

}

// MARK: - ImageLoading

extension ImageLoader: ImageLoading {

  func cachedImage(at url: URL) -> UIImage? {
    let request = URLRequest(url: url)
    guard let cachedData = urlCache.cachedResponse(for: request)?.data else { return nil }
    return UIImage(data: cachedData)
  }

  func fetchImage(at url: URL, completionHandler: ((UIImage) -> Void)? = nil) {
    backgroundQueue.async { [weak self, weak urlSession, weak urlCache] in
      let request = URLRequest(url: url)

      let task = urlSession?.dataTask(with: request) { [weak self] data, response, error in
        guard error == nil else {
          self?.logger.error("Error downloading image: \(error!.localizedDescription)")
          return
        }

        guard
          let data = data,
          let image = UIImage(data: data)
        else {
          self?.logger.error("Unable to decode image data (\(url))")
          return
        }

        let cachedURLResponse = CachedURLResponse(response: response!, data: data)
        urlCache?.storeCachedResponse(cachedURLResponse, for: request)

        completionHandler?(image)
      }

      task?.resume()
    }
  }

}
