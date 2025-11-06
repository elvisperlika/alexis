import Foundation

public protocol PaginationProtocol {

  func hasMore() -> Bool

}

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
public class SearchPaginator: PaginationProtocol {

  let response: SearchResponse
  let client: NotionClient

  /// Initializes a new instance of `SearchPaginator`.
  /// - Parameters:
  ///   - client: The Notion client.
  ///   - response: The search response to paginate.
  init(client: NotionClient, response: SearchResponse) {
    self.client = client
    self.response = response
  }

  /// Indicates whether there are more results to fetch.
  /// - Returns: `true` if there are more results, `false` otherwise.
  public func hasMore() -> Bool {
    return response.hasMore
  }

  /// Fetches the next page of search results if available.
  /// - Returns: The next `SearchResponse` if more results are available, otherwise `nil`.
  public func nextResponse() async throws -> SearchResponse? {
    guard response.hasMore else {
      return nil
    }
    return try await client.search(startCursor: response.nextCursor)
  }

}
