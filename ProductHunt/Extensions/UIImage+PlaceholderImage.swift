import UIKit

extension UIImage {

  static func placeholderImage(sized size: CGSize, color: UIColor) -> UIImage? {
    UIGraphicsBeginImageContext(size)

    color.setFill()
    UIRectFill(CGRect(origin: .zero, size: size))
    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()

    return image
  }

}
