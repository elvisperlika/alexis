//
//  NotionProtocol.swift
//  Alexis
//
//  Created by Elvis Perlika on 30/10/25.
//

protocol NotionProtocol {
    
    func getUsers() async throws -> [User]
    
}
