//
//  Filter.swift
//  Tracker
//
//  Created by vs on 28.05.2024.
//

import Foundation

enum Filter: String, CaseIterable {
    case allTrackers
    case todayTrackers
    case completedTrackers
    case notCompletedTrackers
    
    var description: String {
        switch self {
        case .allTrackers:
            return L10n.allTrackers
        case .todayTrackers:
            return L10n.todayTrackers
        case .completedTrackers:
            return L10n.completedTrackers
        case .notCompletedTrackers:
            return L10n.notCompletedTrackers
        }
    }
}
