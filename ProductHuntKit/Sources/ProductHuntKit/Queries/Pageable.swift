protocol Pageable {
  var cursor: Cursor? { get }
}

extension Pageable {
  var cursorValue: String { cursor?.value ?? "null" }
}
