struct LoadingCellProvider: CellProviding {
  static var reuseIdentifier: String { "LoadingCell" }
  static var cellClass: AnyClass { LoadingCell.self }
}
