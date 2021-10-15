import UIKit
import Dispatch

protocol ImageLoading: AnyObject {

  func cachedImage(at url: URL) -> UIImage?
  func fetchImage(at url: URL, completionHandler: ((UIImage) -> Void)?)

}
