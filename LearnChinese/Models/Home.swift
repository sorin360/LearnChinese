//
//  Home.swift
//  LearnChinese
//
//  Created by Sorin Lica on 11/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import Foundation
import CoreData
import SwiftChart

class Home {
    
    func getChartSeries() -> ChartSeries {
        
        let lastDaysScores = Scores.getLast7DaysScores()
        
        var data: [(x: Double, y: Double)] = []
        for index in 0..<lastDaysScores.count {
            print(lastDaysScores[index].time)
            data += [(x: Double(6 - index), y: Double(lastDaysScores[index].value))]
        }
      
        while data.count < 7 {
            data.insert((x: Double(6 - data.count), y: 0.0), at: data.count )
        }
        
        let series = ChartSeries(data: data)
        series.area = true
        return series
    }
    
    func getWeekDaysLabels() -> [String]{
        
        var labelsAsString: [String] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        for index in 0...6 {
            labelsAsString += [formatter.string(from:  Calendar.current.date(byAdding: .day, value: index, to: Date())!).prefix(3).description]
        }
        return labelsAsString
    }
    
}
