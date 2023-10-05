//
//  GithubSearchViewModel.swift
//  illuminareanCodingTest
//
//  Created by 최제환 on 10/4/23.
//

import Foundation
import UIKit
import Combine

/**
 - GitHub OAuth & Github OpenAPI 참고자료
 https://eunjin3786.tistory.com/211
 https://hilily.tistory.com/38
 */
class GithubSearchViewModel {
    
    // MARK: - Property
    private let clientId = "Iv1.950e3eaec5d9388a"
    private let clientSecret = "10583b71dcea767d8c955677e8af17b6cbe6412a"
    
    let networkProvider = NetworkProvider<NetworkAPI>()
    
    private var accessToken = ""
    private var cancellables = Set<AnyCancellable>()
    
    var keyword = ""
    var currentPage = 1
    var totalCount = 0
    
    @Published private(set) var searchUsers = [SearchUser]()
    @Published private(set) var errorMessage = ""
    
    // MARK: - Custom Method
    
    /// GitHub 로그인 요청 메서드
    /// - Parameters:
    /// - Returns:
    func requestCode() {
        let scope = "repo gist user"
        
        var components = URLComponents(string: "https://github.com/login/oauth/authorize")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: self.clientId),
            URLQueryItem(name: "scope", value: scope),
        ]
        
        let urlString = components.url?.absoluteString
        
        if let url = URL(string: urlString!), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    /// Access Token을 요청하는 메서드
    /// - Parameters:
    ///   - with code: code 값
    /// - Returns:
    func requestAccessToken(with code: String) {
        let requestAccessToken = RequestAccessToken(
            clientId: clientId,
            clientSecret: clientSecret,
            code: code
        )
        
        networkProvider.request(.getAccessToken(requestAccessToken))
            .decode(type: ResponseAccessToken.self, decoder: JSONDecoder())
            .map(\.accessToken)
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if let networkError = error as? NetworkError {
                        self.errorMessage = networkError.errorDescription
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                }
            } receiveValue: { [weak self] accessToken in
                guard let self else { return }
                
                self.accessToken = accessToken
            }
            .store(in: &cancellables)
    }
    
    /// 유저 검색 요청하는 메서드
    /// - Parameters:
    /// - Returns:
    func getUser() {
        let requestSearchUser = RequestSearchUser(
            q: keyword,
            page: currentPage,
            accessToken: accessToken
        )
        
        networkProvider.request(.getUser(requestSearchUser))
            .decode(type: ResponseSearchUser.self, decoder: JSONDecoder())
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if let networkError = error as? NetworkError {
                        self.errorMessage = networkError.errorDescription
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                }
            } receiveValue: { [weak self] responseSearchUser in
                guard let self else { return }
                
                self.totalCount = responseSearchUser.totalCount
                
                if responseSearchUser.items.count > 0 {
                    self.searchUsers.append(contentsOf: responseSearchUser.items)
                } else {
                    self.searchUsers = []
                }
            }
            .store(in: &cancellables)
    }
}
