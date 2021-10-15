import ProductHuntKit

final class DailyPostsPresenter {

  weak var presenterView: DailyPostsPresenterView? {
    didSet {
      paginatedPostsProvider.presenterView = presenterView
    }
  }

  weak var delegate: DailyPostsPresenterDelegate?

  private let paginatedPostsProvider: PaginatedPostsProvider

  init(dataProvider: ProductHuntDataProvider) {
    paginatedPostsProvider = PaginatedPostsProvider(dataProvider: dataProvider, requestType: .daily)
  }

}

// MARK: - DailyPostsPresenting

extension DailyPostsPresenter: DailyPostsPresenting {

  func viewDidLoad() {
    paginatedPostsProvider.fetchMoreResults()
  }

  func didScrollToBottom() {
    paginatedPostsProvider.fetchMoreResults()
  }

  func didSelect(_ post: Post) {
    delegate?.dailyPostsPresenter(self, didSelect: post)
  }

}
