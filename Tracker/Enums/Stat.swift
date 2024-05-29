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
            L10n.statBestPeriod
        case .idealDays:
            L10n.statIdealDays
        case .completedTrackers:
            L10n.statCompletedTrackers
        case .averageValue:
            L10n.statAverageValue
        }
    }
}
