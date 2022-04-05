//
//  Log.swift
//  Hypo
//
//  Created by Andreas Ink on 4/3/22.
//

import SwiftUI

struct Log: Identifiable, Codable, Hashable, Sendable {
    var id: String
    var componets: [Componet] = [Componet(), Componet(), Componet(), Componet(), Componet(), Componet(), Componet(), Componet(), Componet(), Componet(), Componet(), Componet(), Componet(), Componet()]
    var accentColor: Color
    var title: String
    var emoji: String
    
}
struct Componet: Identifiable, Codable, Hashable, Sendable {
    var id: String = UUID().uuidString
    var type: ComponetType = .None
    var text: String = ""
    var accentColor: Color = .accentColor
    var textStyle: String = ""
    var assetName: String = ""
    var componets: [Componet] = []
    var data: [HealthData] = []
}
enum ComponetType: String, Codable, CaseIterable {
    case List = "/List"
    case Table = "/Table"
    case Chart = "/Chart"
    case Image = "/Image"
    case Recording = "/Recording"
    case None = "/None"
}
