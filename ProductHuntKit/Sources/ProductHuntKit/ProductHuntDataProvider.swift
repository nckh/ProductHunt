public protocol ProductHuntDataProvider {

  typealias PostsDecodedResponse = (posts: [Post], cursor: Cursor, hasNextPage: Bool)
  typealias PostsResult = Result<PostsDecodedResponse, Swift.Error>
  typealias PostsCompletionHandler = (PostsResult) -> Void

  typealias PostDetailsResult = Result<PostDetails, Swift.Error>
  typealias PostDetailsCompletionHandler = (PostDetailsResult) -> Void

  func fetchDailyPosts(after cursor: Cursor?, completionHandler: @escaping PostsCompletionHandler)
  func fetchPost(withID: PostIdentifier, completionHandler: @escaping PostDetailsCompletionHandler)

  func fetchPosts(
    votedByUser username: Username,
    after cursor: Cursor?,
    completionHandler: @escaping PostsCompletionHandler
  )

}

extension ProductHuntDataProvider {

  public func fetchDailyPosts(completionHandler: @escaping PostsCompletionHandler) {
    fetchDailyPosts(after: nil, completionHandler: completionHandler)
  }

  public func fetchPosts(votedByUser username: Username, completionHandler: @escaping PostsCompletionHandler) {
    fetchPosts(votedByUser: username, after: nil, completionHandler: completionHandler)
  }

  public func fetchPosts(
    requestType: PostRequestType,
    after cursor: Cursor?,
    completionHandler: @escaping PostsCompletionHandler
  ) {
    switch requestType {
    case .daily:
      fetchDailyPosts(after: cursor, completionHandler: completionHandler)

    case .votedByUser(let username):
      fetchPosts(votedByUser: username, after: cursor, completionHandler: completionHandler)
    }
  }

}

public enum PostRequestType {
  case daily
  case votedByUser(Username)
}
