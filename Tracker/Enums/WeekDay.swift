//
//  WeekDay.swift
//  Tracker
//
//  Created by vs on 05.04.2024.
//

import Foundation

enum WeekDay: Int, CaseIterable, Codable {
    
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    var name: String {
        let weekdaySymbols = calendar.weekdaySymbols
        switch self {
        case .monday:
            return weekdaySymbols[1]
        case .tuesday:
            return weekdaySymbols[2]
        case .wednesday:
            return weekdaySymbols[3]
        case .thursday:
            return weekdaySymbols[4]
        case .friday:
            return weekdaySymbols[5]
        case .saturday:
            return weekdaySymbols[6]
        case .sunday:
            return weekdaySymbols[0]
        }
    }
    
    var shortName: String {
        let weekdaySymbols = calendar.shortWeekdaySymbols
        switch self {
        case .monday:
            return weekdaySymbols[1]
        case .tuesday:
            return weekdaySymbols[2]
        case .wednesday:
            return weekdaySymbols[3]
        case .thursday:
            return weekdaySymbols[4]
        case .friday:
            return weekdaySymbols[5]
        case .saturday:
            return weekdaySymbols[6]
        case .sunday:
            return weekdaySymbols[0]
        }
    }
    
    private var calendar: Calendar { Calendar.current }
    
}
