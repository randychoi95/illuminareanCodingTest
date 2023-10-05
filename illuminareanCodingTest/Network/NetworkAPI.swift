//
//  NetworkAPI.swift
//  illuminareanCodingTest
//
//  Created by 최제환 on 10/4/23.
//

import Foundation
import Moya

/**
 네트워크 통신 모음
 
 참고자료: https://leejigun.github.io/Swift_Moya_Provider_custom
 */
enum NetworkAPI {
    case getAccessToken(RequestAccessToken)
    case getUser(RequestSearchUser)
}

extension NetworkAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .getAccessToken:
            return URL(string: "https://github.com")!
        case .getUser:
            return URL(string: "https://api.github.com")!
        }
    }
    
    var path: String {
        switch self {
        case .getAccessToken:
            return "/login/oauth/access_token"
        case .getUser:
            return "/search/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAccessToken:
            return .post
        case .getUser:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAccessToken(let requestAccessToken):
            return .requestJSONEncodable(requestAccessToken)
        case .getUser(let requestSearchUser):
            var parameters = [String: Any]()
            parameters.updateValue(requestSearchUser.q, forKey: "q")
            parameters.updateValue(requestSearchUser.page, forKey: "page")
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getAccessToken:
            return ["Accept": "application/json"]
        case .getUser(let requestSearchUser):
            return ["Accept": "application/vnd.github.v3+json", "Authorization": "Bearer \(requestSearchUser.accessToken)"]
        }
    }
}
