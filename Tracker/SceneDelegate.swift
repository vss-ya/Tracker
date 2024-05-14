//
//  SceneDelegate.swift
//  Tracker
//
//  Created by vs on 04.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var userDefaults: UserDefaults = UserDefaults.standard
    private var skipOnboarding: Bool {
        set { userDefaults.set(newValue, forKey: "SkipOnboarding") }
        get { userDefaults.bool(forKey: "SkipOnboarding") }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        if skipOnboarding {
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = OnboardingViewController()
            skipOnboarding = true
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}
