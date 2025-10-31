//
//  NotionProtocol.swift
//  Alexis
//
//  Created by Elvis Perlika on 30/10/25.
//

protocol NotionProtocol {
    
    /// Initialize a Notion Client.
    ///
    /// - Parameters:
    ///   - apiKey: The Notion API integration token for authentication.
    ///   - baseURL: The base URL for Notion API endpoints.
    ///   - version: The Notion API version to use.
    init(apiKey: String, baseURL: String, version: String) throws
    
    /// Retrieves a list of users from the Notion workspace.
    ///
    /// - Returns: An array of `UserProtocol` objects representing workspace members.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    func getUsers() async throws -> [UserProtocol]
    
}

protocol UserProtocol {
    var avatarUrl: String { get }
    var name: String { get }
    var email: String { get }
    var type: String { get }
}

protocol DatabaseProtocol {}

protocol EntryProtocol {}
