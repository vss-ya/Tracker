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
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func localized(comment: String = "", arguments: any CVarArg...) -> String {
        return String.localizedStringWithFormat(NSLocalizedString(self, comment: comment), arguments)
    }
    
}
