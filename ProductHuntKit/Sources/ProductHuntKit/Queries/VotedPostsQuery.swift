struct VotedPostsQuery: Query, Pageable {

  let cursor: Cursor?
  private let username: Username
  private let numberOfItemsPerRequest: Int

  var query: String {
    """
      user(username: "\(username)") {
        username,
        name,
        profileImage(size: 64)
        votedPosts(first: \(numberOfItemsPerRequest), after: "\(cursorValue)") {
          pageInfo { endCursor hasNextPage }
          edges {
            node {
              id
              name
              thumbnail {
                type
                url(width: 128, height: 128)
              }
              tagline
              votesCount
              user {
                username
                name
                profileImage(size: 64)
              }
            }
          }
        }
      }
    """
  }

  init(username: Username, cursor: Cursor? = nil, numberOfItemsPerRequest: Int) {
    self.username = username
    self.cursor = cursor
    self.numberOfItemsPerRequest = numberOfItemsPerRequest
  }

}
