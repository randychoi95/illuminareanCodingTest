//
//  RequestSearchUser.swift
//  illuminareanCodingTest
//
//  Created by 최제환 on 10/5/23.
//

import Foundation

struct RequestSearchUser: Codable {
    let q: String
    let page: Int
    let accessToken: String
}
