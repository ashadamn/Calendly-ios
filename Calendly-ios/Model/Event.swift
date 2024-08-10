//
//  Event.swift
//  Calendly-ios
//
//  Created by Mohd Ashad Naushad on 09/08/24.
//

import Foundation
import SwiftData

@Model
class Event: Identifiable{
    var id : String
    var title : String
    var startDate: Date
    var endDate:  Date
    
    init(title: String, startDate: Date, endDate: Date) {
        self.id = UUID().uuidString
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
}
