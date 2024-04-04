//
//  TrackerModels.swift
//  Tracker
//
//  Created by vs on 05.04.2024.
//

import UIKit

struct Tracker {
    let id = UUID()
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]?
}

struct TrackerCategory {
    let header: String
    let trackers: [Tracker]
}

struct TrackerRecord {
    let id: UUID
    let date: Date
}
