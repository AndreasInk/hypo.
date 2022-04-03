//
//  HealthData.swift
//  Hypo
//
//  Created by Andreas Ink on 4/2/22.
//

@preconcurrency import SwiftUI
import SFSafeSymbols

struct HealthData: Identifiable, Codable, Hashable {
    var id: String
    //var type: DataType
    var title: String
    var text: String
    var date: Date
    var endDate: Date?
    var data: Double
    var risk: Double?
    
    
}

struct HealthDataCSV: Codable, Hashable, Sendable {

    var type: String
    var date: [Date]
    var data: [Double]
}
