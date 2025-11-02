import Foundation
import SwiftDotenv
import XCTest

@testable import Alexis

class ClientTests: XCTestCase {

  var client: NotionClient?

  override func setUpWithError() throws {
    try Dotenv.configure()
    let apiKey: String = Dotenv["NOTION_TOKEN"]?.stringValue ?? "Key unavailable"
    client = try NotionClient(apiKey: apiKey)
  }

  func testGetUsers() async throws {
    let users: [UserProtocol]? = try await client?.getUsers()
    XCTAssertNotNil(users)
    XCTAssertFalse(users?.isEmpty ?? true)

    let names: [String]? = users?.map { user in user.name }
    XCTAssertEqual(
      names,
      ["Edoardo Desiderio", "Elvis Unibo", "Eleonora Andrini", "Elvis"]
    )
  }

  func testSearch() async throws {
    let pages = try await client?.search() ?? []
    XCTAssertEqual(
      [Optional("BBBB"), Optional("AAAA")],
      pages.map({ page in page.properties.title.title.first?.plainText }))
  }

}
