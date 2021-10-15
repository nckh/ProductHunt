import UIKit
import ProductHuntKit

protocol PostPresenterView: AnyObject, ErrorPresenterView {
  func setPost(_ post: Post)
  func setPostDetails(_ postDetails: PostDetails)
  func setShowsLoadingIndicator(_ showsLoadingIndicator: Bool)
}
