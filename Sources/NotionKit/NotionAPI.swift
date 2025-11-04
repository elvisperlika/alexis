@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
protocol NotionAPI {

  /// Initialize a Notion Client.
  ///
  /// - Parameters:
  ///   - apiKey: The Notion API integration token for authentication.
  ///   - baseURL: The base URL for Notion API endpoints.
  ///   - version: The Notion API version to use.
  init(apiKey: String, baseURL: String, version: String) throws

  /// Returns all users in the workspace.
  /// [[Notion API Reference](https://developers.notion.com/reference/get-users)]
  ///
  /// - Returns: A paginated list of ``NotionUser`` objects.
  /// - Throws: An error if the request fails.
  func users() async throws -> NotionUsers

  /// Retrieves a specific User by their unique identifier.
  /// [[Notion API Reference](https://developers.notion.com/reference/get-user)]
  ///
  /// - Parameters:
  ///   - userId: The unique identifier of the User to retrieve.
  /// - Returns: A ``NotionUser`` object.
  /// - Throws: An error if the request fails.
  func user(userId: String) async throws -> NotionUser

  /// Retrieves the bot User associated with the API token provided in the authorization header.
  /// The bot will have an owner field with information about the person who authorized the integration.
  /// [[Notion API Reference](https://developers.notion.com/reference/get-self)]
  ///
  /// - Returns: A ``NotionUser`` object representing the bot user.
  /// - Throws: An error if the request fails.
  func me() async throws -> NotionUser

  /// Searches all parent or child pages and data_sources that have been shared with an integration.
  /// Returns all pages or data_sources, excluding duplicated linked databases,
  /// that have titles that include the query param.
  /// [[Notion API Reference](https://developers.notion.com/reference/post-search)]
  ///
  ///  - Parameters:
  ///    - query: A string to search for in page and database titles.
  ///    - filter: An optional ``SearchFilter`` to filter results by object type.
  ///    - sort: An optional ``SearchSort`` to sort results by last edited time.
  ///    - startCursor: An optional string representing the cursor for pagination.
  ///    - pageSize: An optional integer representing the number of results to return per page
  ///
  /// - Returns: A paginated list of ``NotionPage`` objects.
  /// - Throws: An error if the request fails with Server Message != 200.
  func search(
    query: String?,
    filter: SearchFilter?,
    sort: SearchSort?,
    startCursor: String?,
    pageSize: Int?
  ) async throws -> NotionPages

}

public typealias NotionUsers = [NotionUser]

extension NotionUsers {
  public func bots() -> NotionUsers {
    return self.filter { $0.type == .bot }
  }

  public func persons() -> NotionUsers {
    return self.filter { $0.type == .person }
  }

  public func findById(_ id: String) -> NotionUser? {
    return self.first { $0.id == id }
  }
}

public typealias NotionPages = [NotionPage]

extension NotionPages {
  public func findById(_ id: String) -> NotionPage? {
    return self.first { $0.id == id }
  }
}
