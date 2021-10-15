import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {

  let url: URL
  var request: URLRequest?
  var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

  var result: (data: Data?, urlResponse: URLResponse?, error: Error?) {
    didSet {
      resultData = result.data
      resultURLResponse = result.urlResponse
      resultError = result.error
    }
  }

  private var resultData: Data?
  private var resultURLResponse: URLResponse?
  private var resultError: Error?

  init(url: URL) {
    self.url = url
  }

  override func resume() {
    completionHandler?(resultData, resultURLResponse, resultError)
  }

}
