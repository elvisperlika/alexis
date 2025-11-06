import Foundation

public struct NotionPage: Codable {
  /// always "page"
  let object: String
  /// UUID
  let id: NotionID
  /// ISO 8601 format date-time string
  let createdTime: String
  /// User who created the page
  let createdBy: PartialUser
  /// ISO 8601 format date-time string
  let lastEditedTime: String
  /// User who last edited the page
  let lastEditedBy: PartialUser
  /// Indicates whether the page is archived
  let archived: Bool
  /// Indicates whether the page is in the trash
  let inTrash: Bool
  /// Page icon
  let icon: Icon?
  let cover: String?  // TODO: it's a File Object
  let properties: PageProperties
  /// Parent information
  let parent: Parent
  /// i.e. https://www.notion.so/Avocado-d093f1d200464ce78b36e58a3f0d8043
  let url: String
  /// i.e. https://jm-testing.notion.site/p1-6df2c07bfc6b4c46815ad205d132e22d,
  /// if the page is not shared the value is `null`
  let publicUrl: String?

  enum CodingKeys: String, CodingKey {
    case archived, cover, object, parent, properties, id, icon, url
    case createdBy = "created_by"
    case createdTime = "created_time"
    case inTrash = "in_trash"
    case lastEditedBy = "last_edited_by"
    case lastEditedTime = "last_edited_time"
    case publicUrl = "public_url"
  }
}

/// Page Icon
public struct Icon: Codable {
  /// Values: "external", "emoji", "file_upload"
  let type: IconType
  /// if `type == "file"`
  let file: File?
  /// if `type == "external"`
  let external: External?
  /// if `type == "file_upload"`
  let fileUpload: FileUpload?

  enum CodingKeys: String, CodingKey {
    case type, file, external
    case fileUpload = "file_upload"
  }

  public enum IconType: String, Codable {
    case external, emoji
    case fileUpload = "file_upload"
  }
}

// Notion-hosted file (uploaded via UI)
public struct File: Codable {
  let url: String
  let expiryTime: String

  enum CodingKeys: String, CodingKey {
    case url
    case expiryTime = "expiry_time"
  }
}

// File uploaded via the Notion API
public struct FileUpload: Codable {
  let id: NotionID
}

// External file
public struct External: Codable {
  let url: String
}

public struct PartialUser: Codable {
  let object: String
  let id: NotionID
}

public struct Parent: Codable {
  /// Values: "workspace", "page_id", "data_source_id", "database_id, "block_id"
  let type: ParentType
  /// if `type == "data_source_id"`
  let dataSourceId: NotionID?
  /// if `type == "data_source_id"` or `type == "database_id"`
  let databaseId: NotionID?
  /// if `type == "page_id"`
  let pageId: NotionID?
  /// if `type == "workspace"`
  let workspace: Bool?
  /// if `type == "block_id"`
  let blockId: NotionID?

  enum CodingKeys: String, CodingKey {
    case type, workspace
    case pageId = "page_id"
    case databaseId = "database_id"
    case blockId = "block_id"
    case dataSourceId = "data_source_id"
  }

  public enum ParentType: String, Codable {
    case workspace
    case pageId = "page_id"
    case dataSourceId = "data_source_id"
    case databaseId = "database_id"
    case blockId = "block_id"
  }
}

// TODO: Expand with other property types
public struct PageProperties: Codable {
  let title: NotionTitle
}

public struct NotionTitle: Codable {
  let id: NotionID
  let title: [NotionRichText]
  let type: String
}

public struct NotionRichText: Codable {
  let annotations: NotionAnnotations
  let href: String?
  let plainText: String
  let text: NotionTextContent
  let type: String

  enum CodingKeys: String, CodingKey {
    case annotations, href, text, type
    case plainText = "plain_text"
  }
}

public struct NotionAnnotations: Codable {
  let bold: Bool
  let code: Bool
  let color: String
  let italic: Bool
  let strikethrough: Bool
  let underline: Bool
}

public struct NotionTextContent: Codable {
  let content: String
  let link: String?
}

public typealias NotionPages = [NotionPage]

extension NotionPages {

  /// Find a page by its ID
  /// - Parameter id: The ID of the page to find
  /// - Returns: The page with the specified ID, or `nil` if not found
  public func findById(_ id: String) -> NotionPage? {
    return self.first { $0.id == id }
  }
}
