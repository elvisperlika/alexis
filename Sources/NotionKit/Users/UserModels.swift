import Foundation

struct UserListResponse: Codable {
  let object: String
  let results: NotionUsers
  let nextCursor: String?
  let hasMore: Bool

  enum CodingKeys: String, CodingKey {
    case object, results
    case nextCursor = "next_cursor"
    case hasMore = "has_more"
  }
}

public struct NotionUser: Codable {
  /// i.e. "user"
  let object: String
  /// i.e. UUID
  let id: String
  /// Values: "person" or "bot"
  let type: UserType?
  /// present if `type == "person"`
  let person: Person?
  /// present if `type == "bot"`
  let bot: Bot?
  /// i.e. "Avocado"
  let name: String?
  /// i.e. "https://secure.notion-static.com/e6a352a8-8381-44d0-a1dc-9ed80e62b53d.jpg"
  let avatarUrl: String?

  enum CodingKeys: String, CodingKey {
    case object, id, type, person, bot, name
    case avatarUrl = "avatar_url"
  }
}

public typealias NotionUsers = [NotionUser]

extension NotionUsers {
  /// Filters the users to return only bots.
  /// - Returns: A list of bots.
  public func bots() -> NotionUsers {
    return self.filter { $0.type == .bot }
  }

  /// Filters the users to return only persons.
  /// - Returns: A list of persons.
  public func persons() -> NotionUsers {
    return self.filter { $0.type == .person }
  }

  /// Finds a user by their unique identifier.
  /// - Parameter id: The unique identifier of the user.
  /// - Returns: The user with the specified ID, or `nil` if not found.
  public func findById(_ id: String) -> NotionUser? {
    return self.first { $0.id == id }
  }
}

public enum UserType: String, Codable {
  case person
  case bot
}

public struct Person: Codable {
  /// i.e. email@example.com
  let email: String
}

public struct Bot: Codable {
  let owner: BotOwner?
}

/// TODO: Find better solution for class instead of struct (it's to avoid cyclic reference in Codable)
public class BotOwner: Codable {
  /// Values: "user" or "workspace"
  let type: OwnerType
  /// present if `type == "workspace"`
  let workspace: Bool?
  /// present if `type == "workspace"`, in case of `type == "user"` the value is `null`
  let workspaceName: String?
  /// present if `type == "workspace"`
  let workspaceId: String?
  /// present if `type == "user"`
  let user: NotionUser?

  enum CodingKeys: String, CodingKey {
    case type, workspace, user
    case workspaceName = "workspace_name"
    case workspaceId = "workspace_id"
  }
}

public enum OwnerType: String, Codable {
  case user
  case workspace
}
