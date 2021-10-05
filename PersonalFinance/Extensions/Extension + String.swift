//
//  Extension + String.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 16.08.21.
//

import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var digits: String {
            return components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
        }
}

