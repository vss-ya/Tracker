//
//  UserSettingsStorage.swift
//  Tracker
//
//  Created by vs on 26.05.2024.
//

import Foundation

class UserSettingsStorage {
    
    enum Key: String {
        case skipOnboarding = "SkipOnboarding"
    }
    
    static let shared = UserSettingsStorage()
    
    private var userDefaults: UserDefaults = UserDefaults.standard
    
    var skipOnboarding: Bool {
        set { userDefaults.set(newValue, forKey: Key.skipOnboarding.rawValue) }
        get { userDefaults.bool(forKey: Key.skipOnboarding.rawValue) }
    }
    
}
