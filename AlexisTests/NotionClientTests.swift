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
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        client = NotionClient()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetUsers() async throws {
        let users = try await client?.getUsers()
        let names = users?.map { user in user.name }
        XCTAssertEqual(names, ["Edoardo Desiderio", "Elvis Unibo", "Eleonora Andrini", "Elvis"])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
