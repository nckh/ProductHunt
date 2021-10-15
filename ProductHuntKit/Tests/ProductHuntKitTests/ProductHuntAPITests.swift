import XCTest
@testable import ProductHuntKit

final class ProductHuntAPITests: XCTestCase {

  private var productHuntAPI: ProductHuntAPI!
  private var urlSessionMock: URLSessionMock!

  override func setUp() {
    urlSessionMock = URLSessionMock()
    productHuntAPI = ProductHuntAPI(accessToken: "glagla", urlSession: urlSessionMock)
  }

  func testDecodeDailyPostsResponse() {
    let data = Data(Self.dailyPostsResponse.utf8)
    urlSessionMock.results.append((data, nil, nil))

    let expectation = XCTestExpectation()
    var result: ProductHuntDataProvider.PostsResult?

    productHuntAPI.fetchDailyPosts {
      result = $0
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)

    if case let .failure(error) = result {
      XCTFail(error.localizedDescription)
      return
    }

    guard case let .success(decodedResponse) = result else { return }

    XCTAssertEqual(decodedResponse.posts.count, 2)
    XCTAssertEqual(decodedResponse.cursor.value, "XyZ=")
    XCTAssertTrue(decodedResponse.hasNextPage)
  }

  func testDecodePostResponse() {
    let data = Data(Self.postResponse.utf8)
    urlSessionMock.results.append((data, nil, nil))

    let expectation = XCTestExpectation()
    var result: ProductHuntDataProvider.PostDetailsResult?

    productHuntAPI.fetchPost(withID: "123") {
      result = $0
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)

    if case let .failure(error) = result {
      XCTFail(error.localizedDescription)
      return
    }

    guard case let .success(post) = result else { return }

    XCTAssertEqual(post.media.count, 3)
    XCTAssertEqual(post.makers.count, 3)
  }

  func testDecodeVotedPostsResponse() {
    let data = Data(Self.votedPostsResponse.utf8)
    urlSessionMock.results.append((data, nil, nil))

    let expectation = XCTestExpectation()
    var result: ProductHuntDataProvider.PostsResult?

    productHuntAPI.fetchPosts(votedByUser: "gigou") {
      result = $0
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)

    if case let .failure(error) = result {
      XCTFail(error.localizedDescription)
      return
    }

    guard case let .success(decodedResponse) = result else { return }

    XCTAssertEqual(decodedResponse.posts.count, 3)
    XCTAssertEqual(decodedResponse.cursor.value, "XyZ=")
    XCTAssertTrue(decodedResponse.hasNextPage)
  }

  // MARK: - Fake data

  private static var dailyPostsResponse: String {
    """
    {
      "data": {
        "posts": {
          "pageInfo": {
            "endCursor": "XyZ=",
            "hasNextPage": true
          },
          "edges": [
            {
              "node": {
                "id": "111",
                "name": "App 1",
                "tagline": "wesh",
                "votesCount": 7,
                "user": {
                  "username": "hunter1",
                  "name": "Hunter One",
                  "profileImage": "https://ph-static.imgix.net/guest-user-avatar.png"
                },
                "thumbnail": {
                  "url": "https://ph-files.imgix.net/220c5da1-89b1-4b30-8b56-48b77633a159.png"
                }
              }
            },
            {
              "node": {
                "id": "222",
                "name": "App 2",
                "tagline": "gigou",
                "votesCount": 8,
                "user": {
                  "username": "hunter2",
                  "name": "Hunter Two",
                  "profileImage": "https://ph-static.imgix.net/guest-user-avatar.png"
                },
                "thumbnail": {
                  "url": "https://ph-files.imgix.net/e8bc8252-31cc-4918-b172-32eb0c63301a.png"
                }
              }
            }
          ]
        }
      }
    }
    """
  }

  private static var postResponse: String {
    """
    {
      "data": {
        "post": {
          "id": "123",
          "name": "Da Post",
          "tagline": "A great app",
          "description": "A great app blah blah",
          "votesCount": 299,
          "media": [
            {
              "type": "video",
              "url": "https://ph-files.imgix.net/b3185336-d45c-4224-9d70-f7c4c75502ea.jpeg"
            },
            {
              "type": "image",
              "url": "https://ph-files.imgix.net/6f53bad9-b32d-424a-8cc4-9847077b8d65.png"
            },
            {
              "type": "image",
              "url": "https://ph-files.imgix.net/ad05c354-76b5-447f-a54e-a4f0b4eccfb2.gif"
            }
          ],
          "thumbnail": {
            "url": "https://ph-files.imgix.net/de0f4dd6-e2d8-4634-a9fe-92d7f6430a45.png"
          },
          "user": {
            "username": "hunter",
            "name": "Hunter Person",
            "profileImage": "https://ph-static.imgix.net/guest-user-avatar.png"
          },
          "makers": [
            {
              "username": "maker1",
              "name": "Maker One",
              "profileImage": "https://ph-static.imgix.net/guest-user-avatar.png"
            },
            {
              "username": "maker2",
              "name": "Maker Two",
              "profileImage": "https://ph-static.imgix.net/guest-user-avatar.png"
            },
            {
              "username": "maker3",
              "name": "Maker Three",
              "profileImage": "https://ph-static.imgix.net/guest-user-avatar.png"
            }
          ]
        }
      }
    }
    """
  }

  private static var votedPostsResponse: String {
    """
    {
      "data": {
        "user": {
          "username": "gigou",
          "name": "Gigou",
          "profileImage": "https://ph-avatars.imgix.net/222510/original",
          "votedPosts": {
            "pageInfo": {
              "endCursor": "XyZ=",
              "hasNextPage": true
            },
            "edges": [
              {
                "node": {
                  "id": "111",
                  "name": "App 1",
                  "thumbnail": {
                    "type": "image",
                    "url": "https://ph-files.imgix.net/d82aabf1-c553-491e-b473-3c60647ea079.png"
                  },
                  "tagline": "wesh",
                  "votesCount": 7,
                  "user": {
                    "username": "hunter",
                    "name": "Hunter Person",
                    "profileImage": "https://ph-static.imgix.net/guest-user-avatar.png"
                  }
                }
              },
              {
                "node": {
                  "id": "222",
                  "name": "App 2",
                  "thumbnail": {
                    "type": "image",
                    "url": "https://ph-files.imgix.net/a2eeb567-4c4b-4e3a-aa8f-17abebc7afd5.jpeg"
                  },
                  "tagline": "gigou",
                  "votesCount": 8,
                  "user": {
                    "username": "hunter",
                    "name": "Hunter Person",
                    "profileImage": "https://ph-static.imgix.net/guest-user-avatar.png"
                  }
                }
              },
              {
                "node": {
                  "id": "333",
                  "name": "App 3",
                  "thumbnail": {
                    "type": "image",
                    "url": "https://ph-files.imgix.net/70611aae-a3bf-4bec-8fee-3815df1b7320.png"
                  },
                  "tagline": "trululu",
                  "votesCount": 9,
                  "user": {
                    "username": "hunter",
                    "name": "Hunter Person",
                    "profileImage": "https://ph-static.imgix.net/guest-user-avatar.png"
                  }
                }
              }
            ]
          }
        }
      }
    }
    """
  }

}
