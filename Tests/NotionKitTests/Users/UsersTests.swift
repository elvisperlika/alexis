import Foundation
import SwiftDotenv
import XCTest

@testable import NotionKit

class UsersTests: XCTestCase {

  var client: NotionClient?

  override func setUpWithError() throws {
    client = try setupClient()
  }

  func testGetAllUsers() async throws {
    let users: [NotionUser]? = try await client?.users()
    XCTAssertNotNil(users)
    XCTAssertFalse(users?.isEmpty ?? true)

    let names: [String]? = users?.map { user in user.name ?? "" }
    XCTAssertEqual(
      Set(names ?? []),
      Set(["Elvis Unibo", "SwiftKit", "Portfolio"])
    )
  }

  func testGetOnlyBots() async throws {
    let bots: [NotionUser]? = try await client?.users().bots()
    let botsNames = bots?.map({ bot in bot.name ?? "" })
    XCTAssertNotNil(bots)
    XCTAssertEqual(Set(botsNames ?? []), Set(["SwiftKit", "Portfolio"]))
  }

  func testGetOnlyPersons() async throws {
    let users: [NotionUser]? = try await client?.users().persons()
    let personsNames = users?.map({ person in person.name ?? "" })
    XCTAssertNotNil(personsNames)
    XCTAssertEqual(Set(personsNames ?? []), Set(["Elvis Unibo"]))
  }

  func testRetrieveUserById() async throws {
    let users: [NotionUser]? = try await client?.users()
    XCTAssertNotNil(users)
    XCTAssertFalse(users?.isEmpty ?? true)

    if let firstUser = users?.first {
      let retrievedUser: NotionUser? = try await client?.user(userId: firstUser.id)
      XCTAssertNotNil(retrievedUser)
      XCTAssertEqual(retrievedUser?.id, firstUser.id)
      XCTAssertEqual(retrievedUser?.name, firstUser.name)
    } else {
      XCTFail("No users found to test retrieveUserById.")
    }
  }

  func testRetrieveBotUser() async throws {
    let botUser: NotionUser? = try await client?.me()
    XCTAssertNotNil(botUser)
    XCTAssertEqual(botUser?.type, .bot)
    XCTAssertEqual(botUser?.name, "SwiftKit")
  }

}
