import ProductHuntKit
import Dispatch

final class PostPresenter {

  weak var presenterView: PostPresenterView?
  weak var delegate: PostPresenterDelegate?

  private let post: Post
  private let dataProvider: ProductHuntDataProvider

  init(post: Post, dataProvider: ProductHuntDataProvider) {
    self.post = post
    self.dataProvider = dataProvider
  }

  private func fetchAdditionalPostInfo() {
    DispatchQueue.main.async { [weak presenterView] in
      presenterView?.setShowsLoadingIndicator(true)
    }

    dataProvider.fetchPost(withID: post.id) { [weak self, weak presenterView] result in
      DispatchQueue.main.async { [weak self, weak presenterView] in
        presenterView?.setShowsLoadingIndicator(false)

        switch result {
        case let .success(postDetails):
          presenterView?.setPostDetails(postDetails)

        case let .failure(error):
          presenterView?.presentError(message: error.localizedDescription) { [weak self] in
            self?.fetchAdditionalPostInfo()
          }
        }
      }
    }
  }

}

// MARK: - PostPresenting

extension PostPresenter: PostPresenting {

  func viewDidLoad() {
    presenterView?.setPost(post)
    fetchAdditionalPostInfo()
  }

  func didSelect(_ user: User) {
    delegate?.postPresenter(self, didSelect: user)
  }

}
