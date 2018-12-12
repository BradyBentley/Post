//
//  Post.swift
//  Post
//
//  Created by Brady Bentley on 12/10/18.
//  Copyright © 2018 Brady. All rights reserved.
//

import Foundation

struct Post: Codable {
    // MARK: - Properties
    let text: String
    let timestamp: TimeInterval
    let username: String
    
    // MARK: - Initializers
    init(text: String, timestamp: TimeInterval = Date().timeIntervalSince1970, username: String) {
        self.text = text
        self.timestamp = timestamp
        self.username = username
    }
}
