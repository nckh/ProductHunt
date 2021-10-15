import ProductHuntKit

protocol DailyPostsPresenterDelegate: AnyObject {
  func dailyPostsPresenter(_ dailyPostsPresenter: DailyPostsPresenter, didSelect post: Post)
}
