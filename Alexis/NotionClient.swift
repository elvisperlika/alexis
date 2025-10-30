//
//  Alexis.swift
//  Alexis
//
//  Created by Elvis Perlika on 29/10/25.
//

import Foundation

final class NotionClient: NotionProtocol {
    
    private let apiKey: String = ProcessInfo.processInfo.environment["NOTION_TOKEN"] ?? "Unavailable"
    private let baseURL: String = "https://api.notion.com/v1"
    private let notionVersion: String = "2022-06-28"
    
    private var defaultHeaders: [String: String] {
        return [
            "Authorization": "Bearer \(apiKey)",
            "Notion-Version": notionVersion,
            "Content-Type": "application/json"
        ]
    }
    
    private func createRequest(url: URL, method: String, headers: [String: String]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let finalHeaders = headers ?? defaultHeaders
        finalHeaders.forEach { headerField, value in
            request.setValue(value, forHTTPHeaderField: headerField)
        }
        return request
    }
    
    func getUsers() async throws -> [User] {
        let url = URL(string: "\(baseURL)/users")!
        let request = createRequest(url: url, method: "GET")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        
        guard let results = jsonResponse["results"] as? [[String: Any]] else {
            return []
        }
        
        let users = results.compactMap { userDict -> User? in
            return User(from: userDict)
        }
        return users
    }
}
