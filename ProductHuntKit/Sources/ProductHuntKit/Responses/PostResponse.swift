struct PostResponse: Decodable, QueryDecodableResponse {

  let decoded: PostDetails

  init(from decoder: Decoder) throws {
    let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
    let dataContainer = try rootContainer.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)

    self.decoded = try dataContainer.decode(PostDetails.self, forKey: .post)
  }

  enum RootCodingKeys: String, CodingKey {
    case data
  }

  enum DataCodingKeys: String, CodingKey {
    case post
  }

}
