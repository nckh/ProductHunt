import UIKit

final class LoadingCell: UITableViewCell {

  private let activityIndicatorView: UIActivityIndicatorView

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    activityIndicatorView = UIActivityIndicatorView(style: .medium)

    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .clear

    activityIndicatorView.center = center
    activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
    activityIndicatorView.startAnimating()

    addSubview(activityIndicatorView)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    activityIndicatorView.startAnimating()
  }

}
