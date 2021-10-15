import Foundation
import ProductHuntKit

class URLSessionMock: URLSessionProtocol {

  var results = [(Data?, URLResponse?, Error?)]()

  private(set) var dataTasks = [URLSessionDataTaskMock]()

  func dataTask(
    with url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    let task = URLSessionDataTaskMock(url: url)
    task.completionHandler = completionHandler

    if !results.isEmpty {
      task.result = results.removeFirst()
    }

    dataTasks.append(task)
    return task
  }

  func dataTask(
    with request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    let task = dataTask(with: request.url!, completionHandler: completionHandler) as! URLSessionDataTaskMock
    task.request = request
    return task
  }

}
