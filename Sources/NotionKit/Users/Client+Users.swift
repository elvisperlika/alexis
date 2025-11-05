import Foundation

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
extension NotionClient {

  /// Returns all users in the workspace.
  /// [[Notion API Reference](https://developers.notion.com/reference/get-users)]
  ///
  /// - Returns: A paginated list of ``NotionUser`` objects.
  /// - Throws: An error if the request fails.
  public func users() async throws -> NotionUsers {
    let url = URL(string: "\(baseURL)/users")!
    let request = createRequest(baseHeader: self.baseHeader, url: url, method: "GET")
    let (data, response) = try await URLSession.shared.data(for: request)
    try validateResponse(response)
    let usersResponse = try JSONDecoder().decode(UserListResponse.self, from: data)
    return usersResponse.results
  }

  /// Retrieves a specific User by their unique identifier.
  /// [[Notion API Reference](https://developers.notion.com/reference/get-user)]
  ///
  /// - Parameters:
  ///   - userId: The unique identifier of the User to retrieve.
  /// - Returns: A ``NotionUser`` object.
  /// - Throws: An error if the request fails.
  public func user(userId: String) async throws -> NotionUser {
    let url = URL(string: "\(baseURL)/users/\(userId)")!
    let request = createRequest(baseHeader: self.baseHeader, url: url, method: "GET")
    let (data, response) = try await URLSession.shared.data(for: request)
    try validateResponse(response)
    let user = try JSONDecoder().decode(NotionUser.self, from: data)
    return user
  }

  /// Retrieves the bot User associated with the API token provided in the authorization header.
  /// The bot will have an owner field with information about the person who authorized the integration.
  /// [[Notion API Reference](https://developers.notion.com/reference/get-self)]
  ///
  /// - Returns: A ``NotionUser`` object representing the bot user.
  /// - Throws: An error if the request fails.
  public func me() async throws -> NotionUser {
    let url = URL(string: "\(baseURL)/users/me")!
    let request = createRequest(baseHeader: self.baseHeader, url: url, method: "GET")
    let (data, response) = try await URLSession.shared.data(for: request)
    try validateResponse(response)
    let user = try JSONDecoder().decode(NotionUser.self, from: data)
    return user
  }
}
