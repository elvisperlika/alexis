import Foundation
import SwiftDotenv
import XCTest

@testable import Alexis

class SearchTests: XCTestCase {

  var client: NotionClient?

  override func setUpWithError() throws {
    client = try setupClient()
  }

  func testSearchAllPages() async throws {
    let pages = try await client?.fetchPages() ?? []
    XCTAssertEqual(
      Set([Optional("BBBB"), Optional("AAAA")]),
      Set(pages.map({ page in page.properties.title.title.first?.plainText }))
    )
  }
}
