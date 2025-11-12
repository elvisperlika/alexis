import Foundation
import SwiftDotenv
import XCTest

@testable import NotionKit

class PaginationTests: XCTestCase {

  var client: NotionClient?

  override func setUpWithError() throws {
    client = try setupClient()
  }

  func testEmptyPagination() async throws {
    let paginator = SearchPaginator(client: client!)
    XCTAssertFalse(paginator.hasMore())
  }

  func testPaginationNextResponse() async throws {
    let paginator = SearchPaginator(client: client!, size: 1)
    XCTAssertFalse(paginator.hasMore())
    let firstResponse = try await paginator.nextResponse()
    XCTAssertNotNil(firstResponse)
    XCTAssertTrue(paginator.hasMore())
    XCTAssertEqual(firstResponse?.results.count, 1)
  }
}
