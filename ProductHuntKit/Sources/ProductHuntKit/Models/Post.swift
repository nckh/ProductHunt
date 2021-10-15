public typealias PostIdentifier = String

public struct Post: Decodable, Hashable {
  public let id: PostIdentifier
  public let name: String
  public let tagline: String
  public let thumbnail: Image
  public let votesCount: Int
  public let user: User
}
