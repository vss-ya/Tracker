//
//  AppDelegate.swift
//  Tracker
//
//  Created by vs on 04.04.2024.
//

import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackersCoreData")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as? NSError {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
                return
            }
            guard let url = storeDescription.url?.absoluteString else {
                return
            }
            print("Store url - \(url)")
        }
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let configuration = YMMYandexMetricaConfiguration(apiKey: "49065d35-9089-402a-8ef8-ff49e793fc15")
        YMMYandexMetrica.activate(with: configuration!)
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

}
