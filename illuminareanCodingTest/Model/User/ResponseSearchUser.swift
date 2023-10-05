//
//  ResponseSearchUser.swift
//  illuminareanCodingTest
//
//  Created by 최제환 on 10/5/23.
//

import Foundation

struct ResponseSearchUser: Codable {
    var totalCount: Int
    var items: [SearchUser]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

struct SearchUser: Hashable, Identifiable, Codable {
    var id = UUID()
    var login: String
    var avatarUrl: String
    var htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}
