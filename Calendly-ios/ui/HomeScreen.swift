//
//  ContentView.swift
//  Calendly-ios
//
//  Created by Mohd Ashad Naushad on 09/08/24.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var selectedDate = Date()
    @State private var toggle = true
    @State private var isShowingSheet = false
    @State private var eventToEdit: Event?
    @State private var scrollToDate: Date?
    
    @Query(sort: \Event.startDate) var allEvents: [Event]
    
    var groupedEvents: [Date: [Event]] {
        Dictionary(grouping: allEvents, by: { Calendar.current.startOfDay(for: $0.startDate) })
    }
    
    var sortedDates: [Date] {
        groupedEvents.keys.sorted()
    }
    
    var body: some View {
        VStack {
            if toggle {
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .onChange(of: selectedDate) { _ , newDate in
                        
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: toggle)
            }
            
            ScrollViewReader { proxy in
                List {
                    if toggle {
                        ForEach(filteredEvents) { event in
                            ListItem(event: event)
                                .onTapGesture {
                                    eventToEdit = event
                                }
                                .padding(.vertical, 10)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let event = filteredEvents[index]
                                context.delete(event)
                            }
                        }
                    } else {
                        ForEach(sortedDates, id: \.self) { date in
                            Section(header: Text(date.formattedDateWithSuperscript().string)) {
                                ForEach(groupedEvents[date]!) { event in
                                    ListItem(event: event)
                                        .onTapGesture {
                                            eventToEdit = event
                                        }
                                        .padding(.vertical, 10)
                                }
                                .onDelete { indexSet in
                                    let eventsToDelete = indexSet.map { groupedEvents[date]![$0] }
                                    for event in eventsToDelete {
                                        context.delete(event)
                                    }
                                }
                            }
                            .id(date)
                        }
                    }
                }
                .listStyle(.plain)
                .overlay {
                    if (toggle ? filteredEvents : allEvents).isEmpty {
                        ContentUnavailableView(label: {
                            Label("No Events", systemImage: "list.bullet.rectangle.portrait")
                        }, description: {
                            Text("Start adding events.")
                        }, actions: {
                            Button("Add Event") { isShowingSheet = true }
                                .offset(y: -10)
                        })
                        .offset(y: -30)
                    }
                }
                .onChange(of: toggle) {
                    if !toggle {
                        // Scroll to the current date when toggling to the grouped view
                        if let currentDate = sortedDates.first(where: { Calendar.current.isDate($0, inSameDayAs: Date()) }) {
                            scrollToDate = currentDate
                            withAnimation {
                                proxy.scrollTo(scrollToDate, anchor: .top)
                            }
                        }
                    }
                }
            }
            
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            toggle.toggle()
                            selectedDate = .now
                        }
                    } label: {
                        Text( toggle ? "Today" : "Go Back")
                            .bold()
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button {
                        isShowingSheet = true
                    } label: {
                        Text("+ Add Event")
                            .bold()
                    }
                    .padding(.trailing)
                }
                .frame(maxWidth: .infinity, maxHeight: 70)
                .background(Color.lightBlue)
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            AddEventScreen(date: selectedDate)
        }
        .sheet(item: $eventToEdit) { event in
            EditEventScreen(event: event)
        }
    }
    
    private var filteredEvents: [Event] {
        allEvents.filter { event in
            Calendar.current.isDate(event.startDate, inSameDayAs: selectedDate)
        }
    }
}

#Preview {
    HomeScreen()
}
