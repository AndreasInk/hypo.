//
//  HypoApp.swift
//  Shared
//
//  Created by Andreas Ink on 4/2/22.
//

import SwiftUI

@main
struct HypoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
