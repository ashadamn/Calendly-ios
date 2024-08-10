//
//  Calendly_iosApp.swift
//  Calendly-ios
//
//  Created by Mohd Ashad Naushad on 09/08/24.
//

import SwiftUI
import SwiftData

@main
struct Calendly_iosApp: App {
    
    let container : ModelContainer = {
        let schema = Schema([Event.self])
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
