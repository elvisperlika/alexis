import Foundation
import SwiftDotenv
import XCTest

@testable import NotionKit

class IconTests: XCTestCase {

  var client: NotionClient?

  override func setUpWithError() throws {
    client = try setupClient()
  }

  func testPageNotionIcon() async throws {
    let page = try await client?.search()
    let aaaa = page?.results.filter({ page in page.getTitle() == "AAAA"
    }).first
    if case .file(let notionIcon) = aaaa?.icon {
      XCTAssert(notionIcon.type == .external)
    } else {
      XCTFail("Expected Notion icon")
    }
  }

  func testPageIconNone() async throws {
    let page = try await client?.search()
    let aaaa = page?.results.filter({ page in page.getTitle() == "DDDD"
    }).first
    XCTAssertNil(aaaa?.icon)
  }

  func testPageIconEmoji() async throws {
    let page = try await client?.search()
    let bbbb = page?.results.filter({ page in page.getTitle() == "BBBB"
    }).first
    if case .emoji(let emoji) = bbbb?.icon {
      XCTAssertEqual(emoji.emoji, "😀")
    } else {
      XCTFail("Expected emoji icon")
    }
  }

  func testPageIconFile() async throws {
    let page = try await client?.search()
    let cccc = page?.results.filter({ page in page.getTitle() == "CCCC"
    }).first

    if case .file(let fileObject) = cccc?.icon {
      XCTAssert(fileObject.type == .file)
    } else {
      XCTFail("Expected file icon")
    }
  }
}
