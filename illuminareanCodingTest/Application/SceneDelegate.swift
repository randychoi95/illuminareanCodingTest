//
//  SceneDelegate.swift
//  illuminareanCodingTest
//
//  Created by 최제환 on 10/4/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let viewModel = GithubSearchViewModel()
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let githubSearchVC = GithubSearchViewController()
        githubSearchVC.viewModel = self.viewModel
        
        window.rootViewController = githubSearchVC
        self.window = window
        window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
            self.viewModel.requestAccessToken(with: code)
        }
    }
}

