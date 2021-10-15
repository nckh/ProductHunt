import ProductHuntKit

final class UserPresenter {

  weak var presenterView: UserPresenterView? {
    didSet {
      paginatedPostsProvider.presenterView = presenterView
    }
  }

  weak var delegate: UserPresenterDelegate?

  private let user: User
  private let paginatedPostsProvider: PaginatedPostsProvider

  init(user: User, dataProvider: ProductHuntDataProvider) {
    self.user = user

    paginatedPostsProvider = PaginatedPostsProvider(
      dataProvider: dataProvider,
      requestType: .votedByUser(user.username)
    )
  }

}

// MARK: - UserPresenting

extension UserPresenter: UserPresenting {

  func viewDidLoad() {
    presenterView?.setUser(user)
    paginatedPostsProvider.fetchMoreResults()
  }

  func didScrollToBottom() {
    paginatedPostsProvider.fetchMoreResults()
  }

  func didSelect(_ post: Post) {
    delegate?.userPresenter(self, didSelect: post)
  }

}
