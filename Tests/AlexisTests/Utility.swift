import SwiftDotenv
import XCTest

@testable import Alexis

func setupClient() throws -> NotionClient {
  try Dotenv.configure()
  guard let apiKey = Dotenv["NOTION_TOKEN"]?.stringValue else {
    throw NSError(
      domain: "Utility",
      code: 1,
      userInfo: [NSLocalizedDescriptionKey: "NOTION_TOKEN not found"]
    )
  }
  return try NotionClient(apiKey: apiKey)
}
