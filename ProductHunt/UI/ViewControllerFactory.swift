import UIKit
import ProductHuntKit

final class ViewControllerFactory {

  private let imageLoader: ImageLoading

  init(imageLoader: ImageLoading) {
    self.imageLoader = imageLoader
  }

  private var storyboard: UIStoryboard {
    UIStoryboard(name: "Main", bundle: nil)
  }

  func makeDailyPostsViewController(presenter: DailyPostsPresenter) -> DailyPostsViewController {
    DailyPostsViewController(presenter: presenter, imageLoader: imageLoader)
  }

  func makePostViewController(presenter: PostPresenter) -> PostViewController {
    PostViewController(presenter: presenter, imageLoader: imageLoader)
  }

  func makeUserViewController(presenter: UserPresenter) -> UserViewController {
    UserViewController(presenter: presenter, imageLoader: imageLoader)
  }

}
