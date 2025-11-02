import Foundation

struct NotionPage: Codable {
  let archived: Bool
  let cover: String?
  let createdBy: NotionUser
  let createdTime: String
  let icon: String?
  let id: String
  let inTrash: Bool
  let isLocked: Bool
  let lastEditedBy: NotionUser
  let lastEditedTime: String
  let object: String
  let parent: NotionParent
  let properties: NotionProperties
  let publicUrl: String?
  let url: String

  enum CodingKeys: String, CodingKey {
    case archived
    case cover
    case createdBy = "created_by"
    case createdTime = "created_time"
    case icon
    case id
    case inTrash = "in_trash"
    case isLocked = "is_locked"
    case lastEditedBy = "last_edited_by"
    case lastEditedTime = "last_edited_time"
    case object
    case parent
    case properties
    case publicUrl = "public_url"
    case url
  }
}

struct NotionUser: Codable {
  let id: String
  let object: String
}

struct NotionParent: Codable {
  let type: String
  let workspace: Bool
}

struct NotionProperties: Codable {
  let title: NotionTitle
}

struct NotionTitle: Codable {
  let id: String
  let title: [NotionRichText]
  let type: String
}

struct NotionRichText: Codable {
  let annotations: NotionAnnotations
  let href: String?
  let plainText: String
  let text: NotionTextContent
  let type: String

  enum CodingKeys: String, CodingKey {
    case annotations
    case href
    case plainText = "plain_text"
    case text
    case type
  }
}

struct NotionAnnotations: Codable {
  let bold: Bool
  let code: Bool
  let color: String
  let italic: Bool
  let strikethrough: Bool
  let underline: Bool
}

struct NotionTextContent: Codable {
  let content: String
  let link: String?
}

typealias NotionPages = [NotionPage]
