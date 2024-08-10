//
//  Date+Ext.swift
//  Calendly-ios
//
//  Created by Mohd Ashad Naushad on 10/08/24.
//

import SwiftUI

extension Date{
    func formattedDateWithSuperscript() -> NSMutableAttributedString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let dayString = dateFormatter.string(from: self)
        

        let suffix: String
        if let dayInt = Int(dayString) {
            switch dayInt {
            case 1, 21, 31:
                suffix = "st"
            case 2, 22:
                suffix = "nd"
            case 3, 23:
                suffix = "rd"
            default:
                suffix = "th"
            }
        } else {
            suffix = "th"
        }
        
        dateFormatter.dateFormat = "MMM"
        let monthString = dateFormatter.string(from: self)
        
        let attributedString = NSMutableAttributedString(string: dayString)
        
        let suffixAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .baselineOffset: 5
        ]
        
        let suffixAttributedString = NSAttributedString(string: suffix, attributes: suffixAttributes)
        attributedString.append(suffixAttributedString)
        
        let monthAttributedString = NSAttributedString(string: " \(monthString)")
        attributedString.append(monthAttributedString)
        
        return attributedString
    }
}
