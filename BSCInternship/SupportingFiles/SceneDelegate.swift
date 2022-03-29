//
//  SceneDelegate.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let startingViewController = MainViewController()
        let navViewController = UINavigationController(rootViewController: startingViewController)
        window.rootViewController = navViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
