import UIKit
import ProductHuntKit

final class PostViewController: UIViewController {

  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

  private let presenter: PostPresenting
  private let imageLoader: ImageLoading
  private var dataSource: DataSource?

  init(presenter: PostPresenting, imageLoader: ImageLoading) {
    self.presenter = presenter
    self.imageLoader = imageLoader

    super.init(nibName: nil, bundle: nil)

    navigationItem.largeTitleDisplayMode = .never
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
    tableView.register(MediaCellProvider<Section, Item>.self)
    tableView.register(StandardCellProvider.self)
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

extension PostViewController {

  private func initialSnapshot() -> Snapshot {
    var snapshot = dataSource!.snapshot()
    snapshot.appendSections([.main, .hunter])
    return snapshot
  }

}

// MARK: - Section & Items

extension PostViewController {

  enum Section {
    case main, loading, hunter, description, media, makers
  }

  struct Item: CellProvidable {

    let itemType: ItemType
    var cellProvider: CellProviding?

    enum ItemType: Hashable {
      case post(Post)
      case hunter(User)
      case maker(User)
      case description(String)
      case image(URL)
      case loading
    }

  }

}

// MARK: - UITableViewDelegate

extension PostViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    let item = dataSource?.itemIdentifier(for: indexPath)
    switch item?.itemType {
    case .hunter, .maker: return true
    default: return false
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = dataSource?.itemIdentifier(for: indexPath)

    switch item?.itemType {
    case let .hunter(user), let .maker(user):
      presenter.didSelect(user)

    default: break
    }

    tableView.deselectRow(at: indexPath, animated: true)
  }

}

// MARK: - PostPresenterView

extension PostViewController: PostPresenterView {

  func setPost(_ post: Post) {
    title = post.name

    guard let dataSource = dataSource else { return }
    var snapshot = dataSource.snapshot()

    let postItem = Item.post(
      post,
      itemType: .post(post),
      imageLoader: imageLoader,
      dataSource: dataSource,
      showsHunter: false,
      showsDisclosure: false
    )

    let userItem = Item.user(
      post.user,
      itemType: .hunter(post.user),
      imageLoader: imageLoader,
      dataSource: dataSource,
      showsDisclosure: true
    )

    snapshot.appendItems([postItem], toSection: .main)
    snapshot.appendItems([userItem], toSection: .hunter)
    dataSource.apply(snapshot)
  }

  func setPostDetails(_ postDetails: PostDetails) {
    guard let dataSource = dataSource else { return }
    var snapshot = dataSource.snapshot()

    snapshot.appendSections([.description, .media, .makers])

    // Do not animate the section insertion, as the animation effect is dreadful
    dataSource.apply(snapshot, animatingDifferences: false)

    if !postDetails.description.isEmpty {
      let descriptionItem = Item.text(postDetails.description, itemType: .description(postDetails.description))
      snapshot.appendItems([descriptionItem], toSection: .description)
    }

    let makerItems: [Item] = postDetails.makers.map { maker in
      .user(maker, itemType: .maker(maker), imageLoader: imageLoader, dataSource: dataSource, showsDisclosure: true)
    }

    let imageItems: [Item] = postDetails.media
      .filter { $0.type == .image }
      .map { media in
        .image(media.url, itemType: .image(media.url), imageLoader: imageLoader, dataSource: dataSource)
      }

    snapshot.appendItems(makerItems, toSection: .makers)
    snapshot.appendItems(imageItems, toSection: .media)

    // Only animate row insertions
    dataSource.apply(snapshot)
  }

  func setShowsLoadingIndicator(_ showsLoadingIndicator: Bool) {
    guard var snapshot = dataSource?.snapshot() else { return }
    snapshot.deleteSections([.loading])

    if showsLoadingIndicator {
      snapshot.appendSections([.loading])
      snapshot.appendItems([Item.loading(itemType: .loading)], toSection: .loading)
    }

    dataSource?.apply(snapshot, animatingDifferences: false)
  }

}

// MARK: - Data Source

extension PostViewController {

  private final class DataSource: DiffableDataSource<Section, Item> {

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      let section = sectionIdentifier(for: section)
      switch section {
      case .hunter: return "Hunter"
      case .makers: return "Makers"
      default: return nil
      }
    }

  }

}
