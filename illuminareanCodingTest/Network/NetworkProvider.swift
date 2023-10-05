//
//  NetworkProvider.swift
//  illuminareanCodingTest
//
//  Created by 최제환 on 10/4/23.
//

import Foundation
import Moya
import Combine
import CombineMoya

/**
  Moya Provider를 커스터마이징한 OneClickProvider를 이용해 request 통신을 담당하는 클래스
 
 참고자료: https://leejigun.github.io/Swift_Moya_Provider_custom
 */
final class NetworkProvider<Target: TargetType>: MoyaProvider<Target> {
    init(stubClosure: @escaping StubClosure = MoyaProvider.neverStub) {
        let networkClosure = { (_ change: NetworkActivityChangeType, _ target: TargetType) in
            switch change {
            case .began:
                break
            case .ended:
                break
            }
        }
        
        super.init(stubClosure: stubClosure,
                   plugins: [NetworkLoggerPlugin(),
                             NetworkActivityPlugin(networkActivityClosure: networkClosure)])
        
    }
    
    func request(_ target: Target) -> AnyPublisher<Data, NetworkError> {
        self.requestPublisher(target)
            .tryMap { result -> Data in
                guard let response = result.response,
                      (200..<300).contains(response.statusCode)
                else {
                    let response = result.response
                    let statusCode = response?.statusCode ?? -1
                    throw NetworkError.serverError(ServerError(rawValue: statusCode) ?? .unkonown)
                }
                return result.data
            }
            .mapError({ error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.unknownError
                }
            })
            .eraseToAnyPublisher()
    }
}
