public struct PostDetails: Decodable, Hashable {
  public let description: String
  public let makers: [User]
  public let media: [Media]
}
