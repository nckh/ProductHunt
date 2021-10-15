import Foundation

public struct Media: Decodable, Hashable {
  public let url: URL
  public let type: MediaType
}

public enum MediaType: String, Decodable {
  case image, video
}
