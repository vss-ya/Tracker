//
//  Tracker.swift
//  Tracker
//
//  Created by vs on 15.04.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]?
    let pinned: Bool
}
