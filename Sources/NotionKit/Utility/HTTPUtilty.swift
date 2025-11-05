import Foundation

/// Creates a URLRequest with the specified headers, URL, and HTTP method.
///
/// - Parameters:
///   - baseHeader: A dictionary of header fields and their values.
///   - url: The URL for the request.
///   - method: The HTTP method (e.g., "GET", "POST").
/// - Returns: A configured URLRequest.
func createRequest(
  baseHeader: [String: String],
  url: URL,
  method: String
) -> URLRequest {
  var request = URLRequest(url: url)
  request.httpMethod = method
  for (headerField, value) in baseHeader {
    request.setValue(value, forHTTPHeaderField: headerField)
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
