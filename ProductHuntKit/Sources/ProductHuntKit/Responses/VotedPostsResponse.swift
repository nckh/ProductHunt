import Foundation

struct VotedPostsResponse: Decodable, QueryDecodableResponse {

  let decoded: ProductHuntDataProvider.PostsDecodedResponse

  init(from decoder: Decoder) throws {
    let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
    let dataContainer = try rootContainer.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)
    let userContainer = try dataContainer.nestedContainer(keyedBy: UserCodingKeys.self, forKey: .user)

    let votedPostsContainer = try userContainer.nestedContainer(keyedBy: VotedPostsCodingKeys.self, forKey: .votedPosts)
    let pageInfo = try votedPostsContainer.decode(PageInfo.self, forKey: .pageInfo)
    var edgesContainer = try votedPostsContainer.nestedUnkeyedContainer(forKey: .edges)

    let posts = try Self.decodePosts(from: &edgesContainer)

    decoded = (posts, Cursor(pageInfo.endCursor), pageInfo.hasNextPage)
  }

  private static func decodeUser(from container: KeyedDecodingContainer<UserCodingKeys>) throws -> User {
    let name = try container.decode(String.self, forKey: .name)
    let username = try container.decode(String.self, forKey: .username)
    let profileImage = try container.decode(URL.self, forKey: .profileImage)
    return User(name: name, username: username, profileImage: profileImage)
  }

  private static func decodePosts(from container: inout UnkeyedDecodingContainer) throws -> [Post] {
    var posts = [Post]()

    while !container.isAtEnd {
      let edgeContainer = try container.nestedContainer(keyedBy: EdgeCodingKeys.self)
      let post = try edgeContainer.decode(Post.self, forKey: .node)
      posts.append(post)
    }

    return posts
  }

  enum RootCodingKeys: String, CodingKey {
    case data
  }

  enum DataCodingKeys: String, CodingKey {
    case user
  }

  enum UserCodingKeys: String, CodingKey {
    case username, name, profileImage, votedPosts
  }

  enum VotedPostsCodingKeys: String, CodingKey {
    case pageInfo, edges
  }

  enum EdgeCodingKeys: String, CodingKey {
    case node
  }

}
