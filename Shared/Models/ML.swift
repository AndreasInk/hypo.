//
//  ML.swift
//  Hypo
//
//  Created by Andreas Ink on 4/2/22.
//

import SwiftUI
import TabularData
import CreateML

class ML: Tabular {
    func linearRegression(_ df: DataFrame, _ testData: DataFrame, _ targetCol: String) throws -> (AnyColumn, MLLinearRegressor) {
        let model = try MLLinearRegressor(trainingData: df, targetColumn: targetCol)
        
        let predictions = try model.predictions(from: testData)
        return (predictions, model)
    }
}
