//
//  Alexis.swift
//  Alexis
//
//  Created by Elvis Perlika on 29/10/25.
//

import Foundation

final class NotionClient: NotionProtocol {
    
    var baseURL: String
    var notionVersion: String
    var apiKey: String

    init(apiKey: String,
         baseURL: String = Config.Notion.baseURL,
         version: String = Config.Notion.APIVersion
    ) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.notionVersion = version
    }
    
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
    
    func getUsers() async throws -> [UserProtocol] {
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
