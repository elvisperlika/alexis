@available(macOS 10.15.0, *)
protocol NotionAPI {

  /// Initialize a Notion Client.
  ///
  /// - Parameters:
  ///   - apiKey: The Notion API integration token for authentication.
  ///   - baseURL: The base URL for Notion API endpoints.
  ///   - version: The Notion API version to use.
  init(apiKey: String, baseURL: String, version: String) throws

  /// Returns a paginated list of Users for the workspace.
  ///
  /// - Returns: A paginated list of ``NotionUser`` objects.
  /// - Throws: An error if the request fails with Server Message != 200.
  func fetchUsers() async throws -> NotionUsers

  /// Searches all parent or child pages and data_sources that have been shared with an integration.

  /// Returns all pages or data_sources, excluding duplicated linked databases,
  /// that have titles that include the query param.
  ///
  /// - Returns: A paginated list of ``NotionPage`` objects.
  /// - Throws: An error if the request fails with Server Message != 200.
  func fetchPages() async throws -> NotionPages
}

typealias NotionUsers = [NotionUser]

extension NotionUsers {
  func bots() -> NotionUsers {
    return self.filter { $0.type == .bot }
  }

  func persons() -> NotionUsers {
    return self.filter { $0.type == .person }
  }

  func findById(_ id: String) -> NotionUser? {
    return self.first { $0.id == id }
  }
}

typealias NotionPages = [NotionPage]

extension NotionPages {
  func findById(_ id: String) -> NotionPage? {
    return self.first { $0.id == id }
  }
}
