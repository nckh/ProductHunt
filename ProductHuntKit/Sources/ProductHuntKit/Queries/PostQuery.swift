struct PostQuery: Query {

  let id: PostIdentifier

  var query: String {
    """
      post(id:\"\(id)\") {
        id
        name
        tagline
        description
        votesCount
        media {
          type
          url(width: 512, height: 288)
        }
        thumbnail {
          url(width: 128, height: 128)
        }
        user {
          username
          name
          profileImage(size: 64)
        }
        makers {
          username
          name
          profileImage(size: 64)
        }
      }
    """
  }

  init(id: PostIdentifier) {
    self.id = id
  }

}
