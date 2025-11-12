import Foundation

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
public class SearchPaginator: PaginationProtocol {

  var currentResponse: SearchResponse?
  let client: NotionClient
  let pageSize: Int?

  /// Initializes a new instance of `SearchPaginator`.
  /// - Parameters:
  ///   - client: The Notion client.
  ///  - size: The number of pages to fetch per request.
  init(client: NotionClient, size: Int? = nil) {
    self.client = client
    self.pageSize = size
  }

  private func getFirstResponse() async throws -> SearchResponse {
    if currentResponse == nil {
      currentResponse = try await client.search(pageSize: pageSize)
    }
    return currentResponse!
  }

  /// Indicates whether there are more results to fetch.
  /// Indicates whether there are more results to fetch.
  /// - Returns: `true` if there are more results, `false` otherwise.
  public func hasMore() -> Bool {
    return currentResponse?.hasMore ?? false
  }
  /// Fetches the next page of search results if available.
  /// Fetches the next page of search results if available.
  /// - Returns: The next `SearchResponse` if more results are available, otherwise `nil`.
  public func nextResponse() async throws -> SearchResponse? {
    guard currentResponse != nil else {
      currentResponse = try await getFirstResponse()
      return currentResponse
    }
    currentResponse = try await client.search(
      startCursor: currentResponse?.nextCursor,
      pageSize: pageSize)
    return currentResponse
  }

  /// Fetches all pages of search results by iterating through all available pages.
  ///
  /// - Returns: All `NotionPage`s from the search results.
  public func fetchAllPages() async throws -> NotionPages {
    var allResults: NotionPages = []
    if currentResponse == nil {
      currentResponse = try await getFirstResponse()
    }
    allResults.append(contentsOf: currentResponse!.results)
    while hasMore() {
      currentResponse = try await client.search(startCursor: currentResponse?.nextCursor)
      allResults.append(contentsOf: currentResponse!.results)
    }
    return allResults
  }
}
