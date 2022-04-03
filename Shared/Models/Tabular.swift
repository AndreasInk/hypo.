//
//  Tabular.swift
//  Hypo
//
//  Created by Andreas Ink on 4/2/22.
//

import SwiftUI
import TabularData
import HealthKit
import Accelerate

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
        let df =  toDF(healthData)
       
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
       // DispatchQueue.main.async {
          
       
        var groupedData = [[HealthData]]()
        for type in HKQuantityTypeIdentifier.allCases {
            let filteredToType = data.filter { data in
                return data.title == type.rawValue && !data.data.isNaN && data.title != HKQuantityTypeIdentifier.restingHeartRate.rawValue && data.title != HKQuantityTypeIdentifier.activeEnergyBurned.rawValue
            }
            groupedData.append(filteredToType)
        }
        
        var col = Column<Date>(name: "Date", capacity: 100000)
            if let earlyDate = (groupedData.map{$0.map{$0.date}.min() ?? Date()}.min()) {
                if let lateDate = (groupedData.map{$0.map{$0.date}.max() ?? Date()}.max()) {
            col.append(contentsOf: Date.datesHourly(from: earlyDate, to: lateDate))
            df.append(column: col)
                }
            }
         let maxCount = df.shape.rows
        var aggregateData = [Date: Double]()
        for grouped in groupedData {
            if !grouped.isEmpty {
            for slice in grouped.sliced(by: [.hour, .day, .month, .year], for: \.date) {
                if !slice.value.isEmpty {
               
                    aggregateData[slice.key] =  vDSP.mean(slice.value.map{$0.data})
                  
            }
        }
            if !aggregateData.map({$0.value}).isEmpty {
            var col = Column<Double>(name: grouped.map{$0.title}.first ?? "", capacity: maxCount)
            
            col.append(contentsOf: self.fillMissingData(aggregateData.map{$0.value}, maxCount))
            df.append(column: col)
            }
            }
        }
        //}
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
