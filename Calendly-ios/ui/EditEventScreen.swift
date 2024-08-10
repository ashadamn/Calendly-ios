//
//  EditEventScreen.swift
//  Calendly-ios
//
//  Created by Mohd Ashad Naushad on 10/08/24.
//

import SwiftUI

struct EditEventScreen: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var event: Event
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
                    Text("Edit Event for \(event.startDate.formattedDateWithSuperscript())")
                        .font(.headline)
                        .bold()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        updateEvent()
                    }
                }
            }
            .onAppear {
                title = event.title
                startTime = event.startDate
                endTime = event.endDate
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func updateEvent() {
        if title.isEmpty {
            alertMessage = "Please enter a title for the event."
            showAlert = true
        } else if startTime >= endTime {
            alertMessage = "End time must be after start time."
            showAlert = true
        } else {
            event.title = title
            event.startDate = startTime
            event.endDate = endTime
            
            do {
                try context.save()
                dismiss()
            } catch {
                alertMessage = "Failed to save the event. Please try again."
                showAlert = true
            }
            
        }
    }
}
