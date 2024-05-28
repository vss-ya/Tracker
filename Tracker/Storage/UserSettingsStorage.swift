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
        case filter = "Filter"
    }
    
    static let shared = UserSettingsStorage()
    
    private var userDefaults: UserDefaults = UserDefaults.standard
    
    var skipOnboarding: Bool {
        set { userDefaults.set(newValue, forKey: Key.skipOnboarding.rawValue) }
        get { userDefaults.bool(forKey: Key.skipOnboarding.rawValue) }
    }
    
    var filter: Filter {
        set { userDefaults.set(newValue.rawValue, forKey: Key.filter.rawValue) }
        get {
            let value = userDefaults.string(forKey: Key.filter.rawValue) ?? ""
            return Filter(rawValue: value) ?? .allTrackers
        }
    }
    
}
