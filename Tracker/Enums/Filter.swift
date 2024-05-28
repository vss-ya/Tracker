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
            return "AllTrackers".localized()
        case .todayTrackers:
            return "TodayTrackers".localized()
        case .completedTrackers:
            return "CompletedTrackers".localized()
        case .notCompletedTrackers:
            return "NotCompletedTrackers".localized()
        }
    }
}
