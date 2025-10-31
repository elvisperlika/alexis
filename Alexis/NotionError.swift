//
//  NotionError.swift
//  Alexis
//
//  Created by Elvis Perlika on 31/10/25.
//

import Foundation

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
