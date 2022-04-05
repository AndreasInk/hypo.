//
//  Health.swift
//  Hypo
//
//  Created by Andreas Ink on 4/2/22.
//

import SwiftUI
import HealthKit
import Accelerate

@MainActor
class Health: ML {
    let store = HKHealthStore()
    @Published var healthData = [HealthData]()
    @Published var log = [Log]()
    func start() {
        self.store.requestAuthorization(toShare: [], read: Set<HKSampleType>(HKQuantityTypeIdentifier.allCases.map{HKObjectType.quantityType(forIdentifier: $0)!})) { (success, error) in
            self.getAllData()
        }
    }
    func getAllData()  {
        
        for i in HKQuantityTypeIdentifier.allCases.indices {
        
            if let earlyDate = Calendar.current.date(
                byAdding: .month,
                value: -1,
                to: Date()) {
                if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.allCases[i]) {
                    Task {
                    //var rawData = [(String, Date, Double)?]()
                for date in Date.dates(from: earlyDate, to: Date()) {
                    
                    
                if let newData = try await loadNewDataFromHealthKit(type: type, unit: HKUnit.allCases[i], start: date.addingTimeInterval(-84600), end: date) {
                    //rawData.append(newData)
                        
                  
                   
                
                    self.healthData.append(HealthData(id: UUID().uuidString, title: type.identifier, text: "", date: date, data: newData.2))
            }
                    
                                           }
    }
                }
            
        }
    }
        
    }
    
    @discardableResult
    public func loadNewDataFromHealthKit(type: HKSampleType, unit: HKUnit, start: Date, end: Date) async throws -> (String, Date, Double)? {
        

        let (samples, deletedSamples, newAnchor) = try await queryHealthKit(type, startDate: start, endDate: end)
            // Update the anchor.
           // self.anchor = newAnchor
        if let quantitySamples = samples?.compactMap({ sample in
            sample as? HKQuantitySample
        }).map{$0.quantity.doubleValue(for: unit)} {
            print(quantitySamples.first)
            return (type.identifier, start, vDSP.mean(quantitySamples))
            } else {
                
            }

        return nil
    }
     func queryHealthKit(_ type: HKSampleType, startDate: Date, endDate: Date) async throws -> ([HKSample]?, [HKDeletedObject]?, HKQueryAnchor?) {
        return try await withCheckedThrowingContinuation { continuation in
            // Create a predicate that only returns samples created within the last 24 hours.
          
            let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [.strictStartDate, .strictEndDate])
            
            // Create the query.
            let query = HKAnchoredObjectQuery(
                type: type,
                predicate: datePredicate,
                anchor: nil,
                limit: HKObjectQueryNoLimit) { (_, samples, deletedSamples, newAnchor, error) in
                //print(samples)
                // When the query ends, check for errors.
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (samples, deletedSamples, newAnchor))
                }
                
            }
            store.execute(query)
        }
    }
}

