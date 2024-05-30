//
//  Equatable+Extension.swift
//  Tracker
//
//  Created by vs on 30.05.2024.
//

import Foundation

extension Equatable {
    
    func `in`(_ array: Array<Self>) -> Bool {
        return array.contains(self)
    }
    
}
