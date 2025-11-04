public struct SearchResponse: Decodable {
  let object: String
  let results: NotionPages
  let nextCursor: String?
  let hasMore: Bool
  let type: String?
  let pageOrDatabase: [Any]?

  enum CodingKeys: String, CodingKey {
    case object
    case results
    case nextCursor = "next_cursor"
    case hasMore = "has_more"
    case type
    case pageOrDatabase = "page_or_database"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    object = try container.decode(String.self, forKey: .object)
    results = try container.decode(NotionPages.self, forKey: .results)
    nextCursor = try container.decodeIfPresent(String.self, forKey: .nextCursor)
    hasMore = try container.decode(Bool.self, forKey: .hasMore)
    type = try container.decodeIfPresent(String.self, forKey: .type)
    pageOrDatabase = nil  // typically empty object
  }
}

public struct SearchRequest: Encodable {
  let query: String?
  let filter: SearchFilter?
  let sort: SearchSort?
  let startCursor: String?
  let pageSize: Int?

  enum CodingKeys: String, CodingKey {
    case query
    case filter
    case sort
    case startCursor = "start_cursor"
    case pageSize = "page_size"
  }
}

public struct SearchFilter: Encodable {
  let value: Value
  let property: Property

  enum Value: String, Encodable {
    case page = "page"
    case database = "data_source"
  }

  enum Property: String, Encodable {
    case object = "object"
  }
}

public struct SearchSort: Encodable {
  let direction: Direction
  let timestamp: Timestamp

  enum Direction: String, Encodable {
    case ascending = "ascending"
    case descending = "descending"
  }

  enum Timestamp: String, Encodable {
    case lastEditedTime = "last_edited_time"
  }
}
