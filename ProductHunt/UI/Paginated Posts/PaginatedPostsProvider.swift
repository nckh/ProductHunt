import ProductHuntKit
import Dispatch

/// An object that fetch and paginate posts, and update the view every time new results have been fetched.
final class PaginatedPostsProvider {

  weak var presenterView: PaginatedPostsPresenterView?

  private let dataProvider: ProductHuntDataProvider
  private let requestType: PostRequestType
  private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)

  private var cursor: Cursor?
  private var hasNextPage = true
  private var isFetching = false

  init(dataProvider: ProductHuntDataProvider, requestType: PostRequestType) {
    self.dataProvider = dataProvider
    self.requestType = requestType
  }

  func fetchMoreResults() {
    backgroundQueue.async { [weak self] in
      self?.fetch()
    }
  }

  private func fetch() {
    guard !isFetching, hasNextPage else { return }

    isFetching = true

    DispatchQueue.main.async { [weak presenterView] in
      presenterView?.setShowsInlineLoadingIndicator(true)
    }

    dataProvider.fetchPosts(requestType: requestType, after: cursor) { [weak self, weak presenterView] result in
      self?.isFetching = false

      DispatchQueue.main.async { [weak presenterView] in
        presenterView?.setShowsInlineLoadingIndicator(false)
      }

      switch result {
      case let .success((posts, cursor, hasNextPage)):
        self?.cursor = cursor
        self?.hasNextPage = hasNextPage

        DispatchQueue.main.async { [weak presenterView] in
          presenterView?.append(posts)
        }

      case let .failure(error):
        DispatchQueue.main.async { [weak self, weak presenterView] in
          presenterView?.presentError(message: error.localizedDescription) { [weak self] in
            self?.fetchMoreResults()
          }
        }
      }
    }
  }

}
