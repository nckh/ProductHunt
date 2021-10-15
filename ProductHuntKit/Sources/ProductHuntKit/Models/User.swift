import Foundation

public typealias Username = String

public struct User: Decodable, Hashable {
  public let name: String
  public let username: Username
  public let profileImage: URL
}
