import Foundation
import SwiftDotenv
import XCTest

@testable import NotionKit

class SearchTests: XCTestCase {

  var client: NotionClient?

  override func setUpWithError() throws {
    client = try setupClient()
  }

  func testSearchAllPages() async throws {
    let pages = try await client?.search().results ?? []
    XCTAssertEqual(
      Set([Optional("BBBB"), Optional("AAAA"), Optional("CCCC"), Optional("DDDD")]),
      Set(pages.map({ page in page.properties.title.title.first?.plainText }))
    )
  }

  func testSearchPagesOnly() async throws {
    let filter: SearchFilter = SearchFilter(value: .page, property: .object)
    let pages: NotionPages = try await client?.search(filter: filter).results ?? []
    XCTAssertEqual(
      Set([Optional("BBBB"), Optional("AAAA"), Optional("CCCC"), Optional("DDDD")]),
      Set(pages.map({ page in page.properties.title.title.first?.plainText }))
    )
  }

  func testSearchDatabasesOnly() async throws {
    let filter = SearchFilter(value: .data_source, property: .object)
    let pages = try await client?.search(filter: filter).results ?? []
    XCTAssertEqual(0, pages.count)
  }

  func testSearchWithQuery() async throws {
    let pages = try await client?.search(query: "AAA").results ?? []
    XCTAssertEqual(1, pages.count)
    XCTAssertEqual("AAAA", pages.first?.properties.title.title.first?.plainText)
  }

  func testAscendingSortSearch() async throws {
    let sort = SearchSort(direction: .ascending, timestamp: .lastEditedTime)
    let pages = try await client?.search(sort: sort).results ?? []
    let dates = pages.map { $0.lastEditedTime }
    XCTAssertEqual(dates, dates.sorted())
  }

  func testDescendingSortSearch() async throws {
    let sort = SearchSort(direction: .descending, timestamp: .lastEditedTime)
    let pages = try await client?.search(sort: sort).results ?? []
    let dates = pages.map { $0.lastEditedTime }
    XCTAssertEqual(dates, dates.sorted(by: >))
  }

  func testPageSizeLimit() async throws {
    let onePage = try await client?.search(pageSize: 1).results ?? []
    XCTAssertEqual(1, onePage.count)
    let twoPages = try await client?.search(pageSize: 2).results ?? []
    XCTAssertEqual(2, twoPages.count)
  }

}
