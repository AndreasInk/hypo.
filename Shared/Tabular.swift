//
//  Tabular.swift
//  Hypo
//
//  Created by Andreas Ink on 4/2/22.
//

import SwiftUI
import TabularData
import HealthKit

class Tabular: ObservableObject {
    
    func toDF(_ healthData: [HealthDataCSV]) throws -> DataFrame {
        
        let encoder = JSONEncoder()
       
       print(healthData)
        return try DataFrame(jsonData: encoder.encode(healthData))
    }
    func toCSV(_ healthData: [HealthDataCSV], _ fileName: String) throws -> URL {
        let df = try toDF(healthData)
       
        let url = getDocDir().appendingPathComponent(fileName + ".csv")
        try df.writeCSV(to: url)
        return url
    }
    func getDocDir() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    func groupBy( _ data: [HealthData]) -> [HealthDataCSV] {
        var csv = [HealthDataCSV]()
        for type in HKQuantityTypeIdentifier.allCases {
            let filteredToType = data.filter { data in
                return data.title == type.rawValue
            }
            csv.append(HealthDataCSV(type: type.rawValue, date: filteredToType.map{$0.date}, data: filteredToType.map{$0.data}))
            print(csv)
        }
        return csv
    }
}
