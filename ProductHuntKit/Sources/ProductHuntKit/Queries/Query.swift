import Foundation
import OSLog

protocol Query {
  var query: String { get }
}

extension Query {

  var data: Data? {
    let bodyDictionary = [
      "query": "query { \(query) }"
    ]

    do {
      return try JSONSerialization.data(withJSONObject: bodyDictionary)
    } catch {
      logger.error("Failed encoding body to data: \(error.localizedDescription)")
      return nil
    }
  }

  private var logger: Logger {
    Logger(subsystem: "com.nckh.ProductHuntKit", category: "Default")
  }

}
