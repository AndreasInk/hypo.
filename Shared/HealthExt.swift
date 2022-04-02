//
//  HealthExt.swift
//  Hypo
//
//  Created by Andreas Ink on 4/2/22.
//

import HealthKit

extension HKQuantityTypeIdentifier: CaseIterable {
   
    public static var allCases: [HKQuantityTypeIdentifier] {
        return [.restingHeartRate, .heartRateVariabilitySDNN, .restingHeartRate, .respiratoryRate, .heartRate, .activeEnergyBurned, .appleWalkingSteadiness, .numberOfTimesFallen, oxygenSaturation, .walkingSpeed, .walkingStepLength, .walkingAsymmetryPercentage]
    }
    
    
}
extension CaseIterable where Self: RawRepresentable {
    static var allValues: [RawValue] {
            return allCases.map { $0.rawValue }
        }
}

extension HKUnit: CaseIterable {
    public static var allCases: [HKUnit] {
        [.count().unitDivided(by: .minute()), HKUnit(from: "ms"), .count().unitDivided(by: .minute()), .count().unitDivided(by: .minute()), .count().unitDivided(by: .minute()), .largeCalorie(), .percent(), .count(), .percent(), .mile().unitDivided(by: .hour()), .inch(), .percent()]
    }
}
