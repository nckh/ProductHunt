import ProductHuntKit

protocol PostPresenterDelegate: AnyObject {
  func postPresenter(_ postPresenter: PostPresenter, didSelect user: User)
}
