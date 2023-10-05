//
//  RequestAccessToken.swift
//  illuminareanCodingTest
//
//  Created by 최제환 on 10/5/23.
//

import Foundation

struct RequestAccessToken: Codable {
    let clientId: String
    let clientSecret: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case code
    }
}
