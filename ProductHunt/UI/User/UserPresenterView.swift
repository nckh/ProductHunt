import UIKit
import ProductHuntKit

protocol UserPresenterView: PaginatedPostsPresenterView {
  func setUser(_ user: User)
}
