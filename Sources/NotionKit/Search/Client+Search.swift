import Foundation

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
extension NotionClient {

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
  /// - Returns: A ``SearchResponse`` containing the search results and pagination info.
  /// - Throws: An error if the request fails with Server Message != 200.
  public func search(
    query: String? = nil,
    filter: SearchFilter? = nil,
    sort: SearchSort? = nil,
    startCursor: String? = nil,
    pageSize: Int? = nil
  ) async throws -> SearchResponse {
    let url = URL(string: "\(baseURL)/search")!
    let body = try createSearchRequestBody(
      query: query,
      filter: filter,
      sort: sort,
      startCursor: startCursor,
      pageSize: pageSize
    )
    let request = httpHelper.post(baseHeader: baseHeader, url: url, body: body)
    let (data, response) = try await URLSession.shared.data(for: request)
    try httpHelper.validateResponse(response)
    return try JSONDecoder().decode(SearchResponse.self, from: data)
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
    return try JSONEncoder().encode(searchRequest)
  }
}
