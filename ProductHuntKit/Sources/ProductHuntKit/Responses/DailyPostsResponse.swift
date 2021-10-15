struct DailyPostsResponse: Decodable, QueryDecodableResponse {

  let decoded: ProductHuntDataProvider.PostsDecodedResponse

  init(from decoder: Decoder) throws {
    let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
    let dataContainer = try rootContainer.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)
    let postsContainer = try dataContainer.nestedContainer(keyedBy: PostsCodingKeys.self, forKey: .posts)
    let pageInfo = try postsContainer.decode(PageInfo.self, forKey: .pageInfo)
    var edgesContainer = try postsContainer.nestedUnkeyedContainer(forKey: .edges)

    var posts = [Post]()

    while !edgesContainer.isAtEnd {
      let edgeContainer = try edgesContainer.nestedContainer(keyedBy: EdgeCodingKeys.self)
      let post = try edgeContainer.decode(Post.self, forKey: .node)
      posts.append(post)
    }

    decoded = (posts, Cursor(pageInfo.endCursor), pageInfo.hasNextPage)
  }

  enum RootCodingKeys: String, CodingKey {
    case data
  }

  enum DataCodingKeys: String, CodingKey {
    case posts
  }

  enum PostsCodingKeys: String, CodingKey {
    case pageInfo, edges
  }

  enum EdgeCodingKeys: String, CodingKey {
    case node
  }

}
