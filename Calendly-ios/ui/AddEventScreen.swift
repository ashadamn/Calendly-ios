//
//  AddEventScreen.swift
//  Calendly-ios
//
//  Created by Mohd Ashad Naushad on 09/08/24.
//

import SwiftUI

struct AddEventScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var date: Date
    @State private var title: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                    .padding(.vertical, 4)
                
                DatePicker("Start Time", selection: $startTime, displayedComponents: [.hourAndMinute])
                    .padding(.vertical, 4)
                
                DatePicker("End Time", selection: $endTime, displayedComponents: [.hourAndMinute])
                    .padding(.vertical, 4)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Event for \(date.formattedDateWithSuperscript())")
                        .font(.headline)
                        .bold()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEvent()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func saveEvent() {
        let startDate = combineDateAndTime(date: date, time: startTime)
        let endDate = combineDateAndTime(date: date, time: endTime)
        
        if title.isEmpty {
            alertMessage = "Please enter a title for the event."
            showAlert = true
        } else if startDate >= endDate {
            alertMessage = "End time must be after start time."
            showAlert = true
        } else {
            let event = Event(title: title, startDate: startDate, endDate: endDate)
            context.insert(event)
            dismiss()
        }
    }
    
    private func combineDateAndTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        return calendar.date(from: components) ?? Date()
    }


}

#Preview {
    AddEventScreen(date: .now)
}
