struct DailyPostsQuery: Query, Pageable {

  let cursor: Cursor?

  var query: String {
    """
      posts(first: \(numberOfItemsPerRequest), after: "\(cursorValue)") {
        pageInfo {
          endCursor hasNextPage
        }
        edges {
          node {
            id
            name
            tagline
            votesCount
            user {
              username
              name
              profileImage(size: 64)
            }
            thumbnail {
              url(width: 128, height: 128)
            }
          }
        }
      }
    """
  }

  private let numberOfItemsPerRequest: Int

  init(cursor: Cursor? = nil, numberOfItemsPerRequest: Int) {
    self.cursor = cursor
    self.numberOfItemsPerRequest = numberOfItemsPerRequest
  }

}
