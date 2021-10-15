import Foundation

public final class ProductHuntAPI {

  private let accessToken: String
  private let urlSession: URLSessionProtocol
  private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)

  public init(accessToken: String, urlSession: URLSessionProtocol = URLSession.shared) {
    self.accessToken = accessToken
    self.urlSession = urlSession
  }

}

extension ProductHuntAPI: ProductHuntDataProvider {

  public func fetchDailyPosts(after cursor: Cursor?, completionHandler: @escaping PostsCompletionHandler) {
    let query = DailyPostsQuery(cursor: cursor, numberOfItemsPerRequest: Self.numberOfItemsPerRequest)
    fetchData(query: query, decodeResponseTo: DailyPostsResponse.self, completionHandler: completionHandler)
  }

  public func fetchPost(withID postID: PostIdentifier, completionHandler: @escaping PostDetailsCompletionHandler) {
    let query = PostQuery(id: postID)
    fetchData(query: query, decodeResponseTo: PostResponse.self, completionHandler: completionHandler)
  }

  public func fetchPosts(
    votedByUser username: Username,
    after cursor: Cursor?,
    completionHandler: @escaping PostsCompletionHandler
  ) {
    let query = VotedPostsQuery(
      username: username,
      cursor: cursor,
      numberOfItemsPerRequest: Self.numberOfItemsPerRequest
    )

    fetchData(query: query, decodeResponseTo: VotedPostsResponse.self, completionHandler: completionHandler)
  }

  private func fetchData<T: Query, U: QueryDecodableResponse>(
    query: T,
    decodeResponseTo decodingType: U.Type,
    completionHandler: @escaping (Result<U.Decoded, Swift.Error>) -> Void
  ) {
    guard let request = makeRequest(with: query) else { return }

    backgroundQueue.async { [weak urlSession] in
      let dataTask = urlSession?.dataTask(with: request) { data, _, error in
        guard error == nil else {
          completionHandler(.failure(error!))
          return
        }

        guard let data = data else {
          completionHandler(.failure(ProductHuntAPI.Error.unknown))
          return
        }

        let decoder = JSONDecoder()
        do {
          let response = try decoder.decode(decodingType, from: data)
          completionHandler(.success(response.decoded))
        } catch {
          completionHandler(.failure(error))
        }
      }

      dataTask?.resume()
    }

  }

  private func makeRequest(with query: Query) -> URLRequest? {
    var urlComponents = URLComponents()
    urlComponents.host = Self.host
    urlComponents.path = Self.path
    urlComponents.scheme = "https"

    guard let url = urlComponents.url else { return nil }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = [
      "Authorization": "Bearer \(accessToken)",
      "Content-Type": "application/json"
    ]

    guard let data = query.data else { return nil }

    request.httpBody = data
    return request
  }

  private static let host = "api.producthunt.com"
  private static let path = "/v2/api/graphql"
  private static let numberOfItemsPerRequest = 20

  public enum Error: Swift.Error {
    case unknown
  }

}
