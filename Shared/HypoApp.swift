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
    @StateObject var health: Health = Health()
    @State var share = false
    @State var urlName = "HealthData"
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .sheet(isPresented: $share) {
                    
                    ShareSheet(activityItems: [health.getDocDir().appendingPathComponent(urlName + ".csv")])
                    
                }
                .onAppear() {
                    health.start()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    do {
                        try health.toCSV(health.groupBy(health.healthData), urlName)
                    } catch {
                        
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        share = true
                    }
                    }
                }
        }
    }
}
