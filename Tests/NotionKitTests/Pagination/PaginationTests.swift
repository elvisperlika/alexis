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
    let pages = try await client?.search()
    let pagination = SearchPaginator(client: client!, response: pages!)
    XCTAssertFalse(pagination.hasMore())
  }

  func testPaginationNextResponse() async throws {
    let response = try await client?.search(pageSize: 1)
    let pagination = SearchPaginator(client: client!, response: response!)
    XCTAssertTrue(pagination.hasMore())
    let nextPages = try await pagination.nextResponse()
    XCTAssertNotNil(nextPages)
    XCTAssertEqual(nextPages?.results.count, 1)
  }
}
