import Foundation

/// Represents errors that can occur in the NotionKit library.
enum NotionError: LocalizedError {
  case InvalidAPIKey(String)
  case InvalidVersionFormat(String)
  case InvalidURL
  case HttpError

  var errorDescription: String? {
    switch self {
    case .InvalidAPIKey(let message), .InvalidVersionFormat(let message):
      return message
    case .InvalidURL:
      return "Invalid URL"
    case .HttpError:
      return "HTTP request failed"
    }
  }
}
