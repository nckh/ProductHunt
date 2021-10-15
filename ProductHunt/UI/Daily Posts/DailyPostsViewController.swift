import UIKit
import ProductHuntKit

class DailyPostsViewController: UIViewController {

  typealias DataSource = DiffableDataSource<Section, Item>

  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

  private let presenter: DailyPostsPresenting
  private let imageLoader: ImageLoading
  private var dataSource: UITableViewDiffableDataSource<Section, Item>?

  init(presenter: DailyPostsPresenting, imageLoader: ImageLoading) {
    self.presenter = presenter
    self.imageLoader = imageLoader

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = String(localized: "Daily posts", comment: "Top page title")

    let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    tableView.register(PostCellProvider<Section, Item>.self)
    tableView.register(LoadingCellProvider.self)

    dataSource = DataSource(tableView: tableView)
    dataSource?.apply(initialSnapshot())

    tableView.dataSource = dataSource
    tableView.delegate = self

    view.addSubview(tableView)

    presenter.viewDidLoad()
  }

}

// MARK: - Misc

extension DailyPostsViewController {

  private func initialSnapshot() -> Snapshot {
    var snapshot = dataSource!.snapshot()
    snapshot.appendSections([.main])
    return snapshot
  }

}

// MARK: - Section & Items

extension DailyPostsViewController {

  enum Section {
    case main
  }

  struct Item: CellProvidable {

    let itemType: ItemType
    var cellProvider: CellProviding?

    enum ItemType: Hashable {
      case post(Post)
      case loading
    }

  }

}

// MARK: - UITableViewDelegate

extension DailyPostsViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = dataSource?.itemIdentifier(for: indexPath)

    switch item?.itemType {
    case let .post(post): presenter.didSelect(post)
    default: break
    }

    tableView.deselectRow(at: indexPath, animated: true)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.didScrollBeyondBottomBound {
      presenter.didScrollToBottom()
    }
  }

}

// MARK: - DailyPostsPresenterView

extension DailyPostsViewController: DailyPostsPresenterView {

  func append(_ posts: [Post]) {
    guard let dataSource = dataSource else { return }
    var snapshot = dataSource.snapshot()

    let items: [Item] = posts.map { post in
        .post(
          post,
          itemType: .post(post),
          imageLoader: imageLoader,
          dataSource: dataSource,
          showsHunter: true,
          showsDisclosure: true
        )
    }

    snapshot.appendItems(items, toSection: .main)
    dataSource.apply(snapshot)
  }

  func setShowsInlineLoadingIndicator(_ showsAdditionalContentLoadingIndicator: Bool) {
    guard var snapshot = dataSource?.snapshot() else { return }

    snapshot.deleteItems([.loading(itemType: .loading)])
    if showsAdditionalContentLoadingIndicator {
      snapshot.appendItems([.loading(itemType: .loading)], toSection: .main)
    }

    dataSource?.apply(snapshot, animatingDifferences: false)
  }

}
