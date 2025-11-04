import Foundation

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
public final class NotionClient: NotionAPI {

  var baseURL: String
  var notionVersion: String
  var apiKey: String

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

  private func validateResponse(_ response: URLResponse) throws {
    guard let httpResponse = response as? HTTPURLResponse,
      (200...299).contains(httpResponse.statusCode)
    else {
      throw URLError(.badServerResponse)
    }
  }

  public func users() async throws -> NotionUsers {
    let url = URL(string: "\(baseURL)/users")!
    let request = self.createRequest(url: url, method: "GET")
    let (data, response) = try await URLSession.shared.data(for: request)
    try self.validateResponse(response)
    let decoder = JSONDecoder()
    let usersResponse = try decoder.decode(UserListResponse.self, from: data)
    return usersResponse.results
  }

  public func user(userId: String) async throws -> NotionUser {
    let url = URL(string: "\(baseURL)/users/\(userId)")!
    let request = self.createRequest(url: url, method: "GET")
    let (data, response) = try await URLSession.shared.data(for: request)
    try self.validateResponse(response)
    let decoder = JSONDecoder()
    let userResponse = try decoder.decode(NotionUser.self, from: data)
    return userResponse
  }

  public func me() async throws -> NotionUser {
    let url = URL(string: "\(baseURL)/users/me")!
    let request = self.createRequest(url: url, method: "GET")
    let (data, response) = try await URLSession.shared.data(for: request)
    try self.validateResponse(response)
    let decoder = JSONDecoder()
    let botUserResponse = try decoder.decode(NotionUser.self, from: data)
    return botUserResponse
  }

  public func search(
    query: String? = nil,
    filter: SearchFilter? = nil,
    sort: SearchSort? = nil,
    startCursor: String? = nil,
    pageSize: Int? = nil
  ) async throws -> NotionPages {
    let url = URL(string: "\(baseURL)/search")!
    var request = self.createRequest(url: url, method: "POST")

    request.httpBody = try createSearchRequestBody(
      query: query,
      filter: filter,
      sort: sort,
      startCursor: startCursor,
      pageSize: pageSize
    )

    let (data, response) = try await URLSession.shared.data(for: request)
    try self.validateResponse(response)
    let decoder = JSONDecoder()
    let searchResponse = try decoder.decode(SearchResponse.self, from: data)
    return searchResponse.results
  }

  private func createSearchRequestBody(
    query: String?,
    filter: SearchFilter?,
    sort: SearchSort?,
    startCursor: String?,
    pageSize: Int?
  ) throws -> Data {
    let searchRequest = SearchRequest(
      query: query,
      filter: filter,
      sort: sort,
      startCursor: startCursor,
      pageSize: pageSize
    )
    let encoder = JSONEncoder()
    return try encoder.encode(searchRequest)
  }
}
