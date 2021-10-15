import ProductHuntKit

protocol UserPresenterDelegate: AnyObject {
  func userPresenter(_ userPresenter: UserPresenter, didSelect post: Post)
}
