import Foundation

class HTTPHelper {

  enum HTTPMethod: String {
    case GET
    case PUT
    case POST
    case PATCH
    case DELETE
  }

  func post(baseHeader: [String: String], url: URL, body: Data) -> URLRequest {
    return createRequest(baseHeader: baseHeader, url: url, method: HTTPMethod.POST, body: body)
  }

  func get(baseHeader: [String: String], url: URL) -> URLRequest {
    return createRequest(baseHeader: baseHeader, url: url, method: HTTPMethod.GET)
  }

  /// Creates a URLRequest with the specified headers, URL, and HTTP method.
  ///
  /// - Parameters:
  ///   - baseHeader: A dictionary of header fields and their values.
  ///   - url: The URL for the request.
  ///   - method: The HTTP method.
  /// - Returns: A configured URLRequest.
  private func createRequest(
    baseHeader: [String: String],
    url: URL,
    method: HTTPMethod,
    body: Data? = nil
  ) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    for (headerField, value) in baseHeader {
      request.setValue(value, forHTTPHeaderField: headerField)
    }
    if let body = body {
      request.httpBody = body
    }
    return request
  }

  /// Validates the HTTP response.
  ///
  /// - Parameter response: The URLResponse to validate.
  /// - Throws: An error if the response status code is not in the 200-299 range.
  func validateResponse(_ response: URLResponse) throws {
    guard let httpResponse = response as? HTTPURLResponse,
      (200...299).contains(httpResponse.statusCode)
    else {
      throw URLError(.badServerResponse)
    }
  }

}
