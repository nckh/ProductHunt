import UIKit
import ProductHuntKit

final class Coordinator {

  private let window: UIWindow
  private var dataProvider: ProductHuntDataProvider
  private let navigationController: UINavigationController = {
    let navigationController = UINavigationController()
    navigationController.navigationBar.prefersLargeTitles = true
    return navigationController
  }()

  private let viewControllerFactory: ViewControllerFactory
  private let imageLoader = ImageLoader()

  init(window: UIWindow) {
    self.window = window

    let key = Self.productHuntAPIAccessTokenKey
    guard let accessToken = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
      fatalError("Missing access token in Info.plist")
    }

    dataProvider = ProductHuntAPI(accessToken: accessToken)
    viewControllerFactory = ViewControllerFactory(imageLoader: imageLoader)

    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    showDailyPosts()
  }

  private func showDailyPosts() {
    let dailyPostsPresenter = DailyPostsPresenter(dataProvider: dataProvider)
    let dailyPostsViewController = viewControllerFactory.makeDailyPostsViewController(presenter: dailyPostsPresenter)
    dailyPostsPresenter.delegate = self
    dailyPostsPresenter.presenterView = dailyPostsViewController

    navigationController.pushViewController(dailyPostsViewController, animated: true)
  }

  private func show(_ post: Post) {
    let presenter = PostPresenter(post: post, dataProvider: dataProvider)
    let viewController = viewControllerFactory.makePostViewController(presenter: presenter)
    presenter.delegate = self
    presenter.presenterView = viewController

    navigationController.pushViewController(viewController, animated: true)
  }

  private func show(_ user: User) {
    let presenter = UserPresenter(user: user, dataProvider: dataProvider)
    let viewController = viewControllerFactory.makeUserViewController(presenter: presenter)
    presenter.delegate = self
    presenter.presenterView = viewController

    navigationController.pushViewController(viewController, animated: true)
  }

  private static let productHuntAPIAccessTokenKey = "ProductHuntAPIAccessToken"

}

// MARK: - DailyPostsPresenterDelegate

extension Coordinator: DailyPostsPresenterDelegate {

  func dailyPostsPresenter(_ dailyPostsPresenter: DailyPostsPresenter, didSelect post: Post) {
    show(post)
  }

}

// MARK: - PostPresenterDelegate

extension Coordinator: PostPresenterDelegate {

  func postPresenter(_ postPresenter: PostPresenter, didSelect user: User) {
    show(user)
  }

}

// MARK: - UserPresenterDelegate

extension Coordinator: UserPresenterDelegate {

  func userPresenter(_ userPresenter: UserPresenter, didSelect post: Post) {
    show(post)
  }

}
