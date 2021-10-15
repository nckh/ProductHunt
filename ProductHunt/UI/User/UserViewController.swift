import UIKit
import ProductHuntKit

final class UserViewController: UIViewController {

  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

  private let presenter: UserPresenting
  private let imageLoader: ImageLoading
  private var dataSource: DataSource?

  init(presenter: UserPresenting, imageLoader: ImageLoading) {
    self.presenter = presenter
    self.imageLoader = imageLoader

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    tableView.register(PostCellProvider<Section, Item>.self)
    tableView.register(UserCellProvider<Section, Item>.self)
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

extension UserViewController {

  private func initialSnapshot() -> Snapshot {
    var snapshot = dataSource!.snapshot()
    snapshot.appendSections([.profile])
    return snapshot
  }

}

// MARK: - Section & Items

extension UserViewController {

  enum Section {
    case profile, votedPosts, loading
  }

  struct Item: CellProvidable {

    let itemType: ItemType
    var cellProvider: CellProviding?

    enum ItemType: Hashable {
      case user(User)
      case post(Post)
      case loading
    }

  }

}

// MARK: - UITableViewDelegate

extension UserViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    let item = dataSource?.itemIdentifier(for: indexPath)
    switch item?.itemType {
    case .post: return true
    default: return false
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = dataSource?.itemIdentifier(for: indexPath)

    switch item?.itemType {
    case let .post(post):
      presenter.didSelect(post)

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

// MARK: - UserPresenterView

extension UserViewController: UserPresenterView {

  func setUser(_ user: User) {
    title = user.username

    guard let dataSource = dataSource else { return }
    var snapshot = dataSource.snapshot()

    let userItem = Item.user(
      user,
      itemType: .user(user),
      imageLoader: imageLoader,
      dataSource: dataSource,
      showsDisclosure: false
    )

    snapshot.appendItems([userItem], toSection: .profile)
    dataSource.apply(snapshot)
  }

  func append(_ posts: [Post]) {
    guard
      !posts.isEmpty,
      let dataSource = dataSource
    else {
      return
    }

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

    snapshot.appendSectionIfNeeded(.votedPosts)

    // Do not animate the section insertion, as the animation effect is dreadful
    dataSource.apply(snapshot, animatingDifferences: false)

    snapshot.appendItems(items, toSection: .votedPosts)

    // Only animate row insertions
    dataSource.apply(snapshot)
  }

  func setShowsInlineLoadingIndicator(_ showsLoadingIndicator: Bool) {
    guard var snapshot = dataSource?.snapshot() else { return }

    let firstPostsFetched = snapshot.sectionIdentifiers.contains(.votedPosts)

    // If no post has been fetched yet, the loading indicator is displayed in its own section.
    // Otherwise, it is added to the bottom of the .votedPosts section.
    // This is only for cosmetic purposes, in order to not display an empty section if the user hasn't upvoted any post.

    let loadingItem = Item.loading(itemType: .loading)

    switch (firstPostsFetched, showsLoadingIndicator) {
    case (false, true):
      snapshot.insertSectionIfNeeded(.loading, afterSection: .profile)
      snapshot.appendItems([loadingItem], toSection: .loading)

    case (false, false):
      snapshot.deleteSections([.loading])

    case (true, true):
      snapshot.appendItems([loadingItem], toSection: .votedPosts)

    case (true, false):
      snapshot.deleteItems([loadingItem])
    }

    dataSource?.apply(snapshot, animatingDifferences: false)
  }

}

// MARK: - Data Source

extension UserViewController {

  private final class DataSource: DiffableDataSource<Section, Item> {

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      let section = sectionIdentifier(for: section)
      switch section {
      case .votedPosts: return "Upvoted"
      default: return nil
      }
    }

  }

}
