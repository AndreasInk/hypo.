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
    
//    func toDF(_ healthData: [HealthDataCSV]) throws -> DataFrame {
//        let df = DataFrame()
//        let encoder = JSONEncoder()
//
//       print("ENCODINF")
//       print(healthData)
//        return try
//    }
    func toCSV(_ healthData: [HealthData], _ fileName: String) throws -> URL {
        let df = try toDF(healthData)
       
        let url = getDocDir().appendingPathComponent(fileName + ".csv")
        try df.writeCSV(to: url)
        return url
    }
    func getDocDir() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    func toDF( _ data: [HealthData]) -> DataFrame {
        var df = DataFrame()
        var groupedData = [[HealthData]]()
        for type in HKQuantityTypeIdentifier.allCases {
            let filteredToType = data.filter { data in
                return data.title == type.rawValue && !data.data.isNaN
            }
            groupedData.append(filteredToType)
        }
        if let maxCount = groupedData.map({$0.count}).max() {
        for grouped in groupedData {
            if !grouped.isEmpty {
                if let name = grouped.first?.title {
                    
                    let col = Column(name:  name, contents: fillMissingData(grouped.map{$0.data}, maxCount))
                print(col)
                df.append(column: col)
                }
            //csv.append(HealthDataCSV(type: type.rawValue, date: filteredToType.map{$0.date}, data: filteredToType.map{$0.data}))
            }
        }
        }
        return df
    }
    func fillMissingData(_ data: [Double], _ max: Int) -> [Double] {
        var data = data
        print("DATA COUNT")
        print(data.count)
        print("MAX")
        print(max)
        if max > data.count {
        for i in data.count...max - 1 {
            data.append(0)
        }
        }
        print("NEW DATA COUNt")
        print(data.count)
        return data
    }
}
