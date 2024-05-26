//
//  SceneDelegate.swift
//  Tracker
//
//  Created by vs on 04.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var userSettings: UserSettingsStorage = .shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        if userSettings.skipOnboarding {
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = OnboardingViewController { [weak self]() in
                guard let self else { return }
                userSettings.skipOnboarding = true
                window?.rootViewController = TabBarController()
            }
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}
