import Foundation

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
public final class NotionClient: NotionProtocol {

  var baseURL: String
  var notionVersion: String
  var apiKey: String
  var baseHeader: [String: String] {
    return [
      "Authorization": "Bearer \(self.apiKey)",
      "Notion-Version": self.notionVersion,
      "Content-Type": "application/json",
    ]
  }

  public init(
    apiKey: String,
    baseURL: String = Config.Notion.baseURL,
    version: String = Config.Notion.APIVersion
  ) throws {
    guard apiKey.count >= 16 else {
      throw
        NotionError
        .InvalidAPIKey("API key must be at least 16 characters longs")
    }

    let versionPattern = #"^\d{4}-\d{2}-\d{2}$"#
    let versionRegex = try NSRegularExpression(pattern: versionPattern)
    let versionRange = NSRange(version.startIndex..., in: version)

    guard versionRegex.firstMatch(in: version, range: versionRange) != nil
    else {
      throw
        NotionError
        .InvalidVersionFormat("Version must be in format YYYY-MM-DD")
    }

    self.apiKey = apiKey
    self.baseURL = baseURL
    self.notionVersion = version
  }

}
