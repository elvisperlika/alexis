import Foundation

@available(macOS 10.15.0, *)
final class NotionClient: NotionAPI {

  var baseURL: String
  var notionVersion: String
  var apiKey: String

  init(
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

  private var defaultHeaders: [String: String] {
    return [
      "Authorization": "Bearer \(self.apiKey)",
      "Notion-Version": self.notionVersion,
      "Content-Type": "application/json",
    ]
  }

  private func createRequest(
    url: URL, method: String,
    headers: [String: String]? = nil
  ) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method

    let finalHeaders = headers ?? self.defaultHeaders
    for (headerField, value) in finalHeaders {
      request.setValue(value, forHTTPHeaderField: headerField)
    }
    return request
  }

  func fetchUsers() async throws -> NotionUsers {
    let url = URL(string: "\(baseURL)/users")!
    let request = self.createRequest(url: url, method: "GET")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode == 200
    else {
      throw URLError(.badServerResponse)
    }

    let decoder = JSONDecoder()
    let usersResponse = try decoder.decode(UserListResponse.self, from: data)
    return usersResponse.results
  }

  func fetchPages() async throws -> NotionPages {
    let url = URL(string: "\(baseURL)/search")!
    let request = self.createRequest(url: url, method: "POST")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode == 200
    else {
      throw URLError(.badServerResponse)
    }

    let decoder = JSONDecoder()
    let searchResponse = try decoder.decode(NotionSearchResponse.self, from: data)
    return searchResponse.results
  }
}
