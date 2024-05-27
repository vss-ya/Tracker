//
//  TrackerOption.swift
//  Tracker
//
//  Created by vs on 15.04.2024.
//

enum TrackerOption {
    case category
    case schedule
    
    var title: String {
        switch self {
        case .category:
            "Category".localized()
        case .schedule:
            "Schedule".localized()
        }
    }
    
}
