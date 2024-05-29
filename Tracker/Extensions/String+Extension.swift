//
//  String+Extension.swift
//  Tracker
//
//  Created by vs on 14.05.2024.
//

import Foundation

extension String {
    
    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    mutating func trim() {
        self = trimmed()
    }
    
}
