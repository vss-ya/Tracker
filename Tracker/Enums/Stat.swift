//
//  Stat.swift
//  Tracker
//
//  Created by vs on 29.05.2024.
//

import Foundation

enum Stat: String, CaseIterable {
    case bestPeriod
    case idealDays
    case completedTrackers
    case averageValue
    
    var description: String {
        switch self {
        case .bestPeriod:
            return "StatBestPeriod".localized()
        case .idealDays:
            return "StatIdealDays".localized()
        case .completedTrackers:
            return "StatCompletedTrackers".localized()
        case .averageValue:
            return "StatAverageValue".localized()
        }
    }
}
