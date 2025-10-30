//
//  NotionUser.swift
//  Alexis
//
//  Created by Elvis Perlika on 29/10/25.
//

import Foundation

struct User {
    let avatarUrl: String
    let name: String
    let email: String
    let type: String
    
    init(avatarUrl: String, name: String, email: String, type: String) {
        self.avatarUrl = avatarUrl
        self.name = name
        self.email = email
        self.type = type
    }
}

extension User {
    init?(from dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let type = dictionary["type"] as? String,
              let avatarUrl = dictionary["avatar_url"] as? String
        else {
            return nil
        }

        var email: String? = nil
        if let person = dictionary["person"] as? [String: Any] {
            email = person["email"] as? String
        }
        
        self.init(
            avatarUrl: avatarUrl,
            name: name,
            email: email ?? "bot",
            type: type
        )
    }
}
