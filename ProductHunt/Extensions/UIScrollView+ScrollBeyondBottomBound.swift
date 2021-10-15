import UIKit

extension UIScrollView {

  var didScrollBeyondBottomBound: Bool {
    // Ignore initial call to `UIScrollViewDelegate.scrollViewDidScroll` after the view controller appeared.
    guard contentOffset.y > 0 else { return false }

    let maxContentOffsetY = contentSize.height - bounds.height + safeAreaInsets.bottom
    return contentOffset.y > maxContentOffsetY
  }

}
