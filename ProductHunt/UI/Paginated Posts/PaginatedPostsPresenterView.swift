import ProductHuntKit

protocol PaginatedPostsPresenterView: AnyObject, ErrorPresenterView {
  func setShowsInlineLoadingIndicator(_ showsLoadingIndicator: Bool)
  func append(_ posts: [Post])
}
