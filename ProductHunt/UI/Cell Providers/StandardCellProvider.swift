import UIKit

struct StandardCellProvider: CellProviding {

  private let text: String

  init(text: String) {
    self.text = text
  }

  func update(_ contentConfiguration: inout UIListContentConfiguration) {
    contentConfiguration.text = text
  }

  static let reuseIdentifier: String = "Standard"

}
