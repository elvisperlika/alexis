import Foundation

struct UserListResponse: Codable {
  let object: String
  let results: [NotionUser]
  let nextCursor: String?
  let hasMore: Bool

  enum CodingKeys: String, CodingKey {
    case object, results
    case nextCursor = "next_cursor"
    case hasMore = "has_more"
  }
}

public struct NotionUser: Codable {
  let object: String
  let id: String
  let type: UserType
  let person: Person?
  let bot: Bot?
  let name: String?
  let avatarUrl: String?

  enum CodingKeys: String, CodingKey {
    case object, id, type, person, bot, name
    case avatarUrl = "avatar_url"
  }
}

public enum UserType: String, Codable {
  case person
  case bot
}

public struct Person: Codable {
  let email: String
}

public struct Bot: Codable {
  let owner: BotOwner?
}

public class BotOwner: Codable {
  let type: String
  let user: NotionUser?
}
