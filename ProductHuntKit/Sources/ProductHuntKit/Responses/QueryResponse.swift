protocol QueryDecodableResponse: Decodable {

  associatedtype Decoded
  var decoded: Decoded { get }

}
