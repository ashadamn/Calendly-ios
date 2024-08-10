//
//  ListItem.swift
//  Calendly-ios
//
//  Created by Mohd Ashad Naushad on 09/08/24.
//

import SwiftUI

struct ListItem: View {
    
    var event : Event
    
    var body: some View {
        HStack{
            
            Rectangle()
                .frame(width: 2)
                .foregroundColor(.red)
            
            Text(event.title)
                .fontWeight(.bold)
                .font(.title3)
            
            Spacer()
            
            VStack{
                Text(formatTime(from: event.startDate))
                    .foregroundColor(.gray)
                    .font(.subheadline)
                Text(formatTime(from: event.endDate))
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
        }
        .frame(height: 40)
        .background(.white)
    }
    
    func formatTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    ListItem(event: Event(title: "Title", startDate: Date(), endDate: Date()))
}
