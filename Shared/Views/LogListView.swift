//
//  LogView.swift
//  Hypo
//
//  Created by Andreas Ink on 4/3/22.
//

import SwiftUI

struct LogListView: View {
    @ObservedObject var health: Health
    @State var add = false
    @State var log = Log(id: UUID().uuidString, accentColor: .accentColor, title: "", emoji: "")
    var body: some View {
        List {
            ForEach(Array(zip($health.log, health.log)), id: \.1.id) { $log, log in
                HStack {
                    ZStack {
                    Circle()
                        .frame(maxWidth: 75)
                        .padding()
                        .foregroundColor(log.accentColor)
                        Text(log.emoji)
                        
                    }
                }
            }
        } .toolbar {
            ToolbarItemGroup(placement: ToolbarItemPlacement.navigationBarTrailing) {
                NavigationLink(isActive: $add, destination: {
                    LogView(log: $log, health: health)
                }, label: {
                    Image(systemSymbol: .plus)
                })

            }
        }
        
    }
}

