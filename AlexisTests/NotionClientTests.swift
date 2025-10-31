//
//  AlexisTests.swift
//  AlexisTests
//
//  Created by Elvis Perlika on 29/10/25.
//

import XCTest
@testable import Alexis

final class NotionClientTests: XCTestCase {
    
    var client: NotionClient? = nil
    
    override func setUp() {
        let apiKey: String = ProcessInfo.processInfo.environment["NOTION_TOKEN"] ?? "Unavailable"
        client = NotionClient(apiKey: apiKey)
    }

    func testGetUsers() async throws {
        let users = try await client?.getUsers()
        XCTAssertNotNil(users)
        XCTAssertFalse(users?.isEmpty ?? true)
        
        let names = users?.map { user in user.name }
        XCTAssertEqual(names, ["Edoardo Desiderio", "Elvis Unibo", "Eleonora Andrini", "Elvis"])
    }

}
