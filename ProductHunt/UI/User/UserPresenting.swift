import ProductHuntKit

protocol UserPresenting {
  func viewDidLoad()
  func didScrollToBottom()
  func didSelect(_ post: Post)
}
