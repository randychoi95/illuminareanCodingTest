//
//  ResponseAccessToken.swift
//  illuminareanCodingTest
//
//  Created by 최제환 on 10/5/23.
//

import Foundation

struct ResponseAccessToken: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
    let refreshTokenExpiresIn: Int
    let scope, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case refreshTokenExpiresIn = "refresh_token_expires_in"
        case scope
        case tokenType = "token_type"
    }
}
