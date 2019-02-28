//
//  Scores.swift
//  LearnChinese
//
//  Created by Sorin Lica on 06/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Scores: NSManagedObject {
    static func addScore(in context: NSManagedObjectContext){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let newScore = Scores(context: managedContext)
        newScore.time = Date()
        newScore.value = 0
        do {
            try managedContext.save()
        
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func update(with score: Int, at date: Date){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Scores")

        fetchRequest.predicate = NSPredicate(format: "%K == %@", "time", date as CVarArg)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            if test.count > 0 {
                let objectUpdate = test[0] as! Scores //
                objectUpdate.value += Int16(score)
            } else {
                let newScore = Scores(context: managedContext)
                newScore.time = date.stripTime()
                newScore.value = Int16(score)
            }
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
        
    }
    static func getLast7DaysScores() -> [Scores] {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            let managedContext = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Scores")
            let sort = NSSortDescriptor(key: "time", ascending: false)
            
            fetchRequest.sortDescriptors = [sort]

            do {
                var result = try managedContext.fetch(fetchRequest) as? [Scores] ?? []
                let today = Date()
                var index = 0
                while index < result.count{
                    // if the time for a certain score is different than the expected time for that score then a new score object is created and added to the results list
                    if result[index].time != Calendar.current.date(byAdding: .day, value: 0 - index, to: today)?.stripTime()
                    {
                        let newScore = Scores(context: managedContext)
                        newScore.time = Calendar.current.date(byAdding: .day, value: 0 - index, to: today)?.stripTime()
                        newScore.value = 0
                            
                        result.insert(newScore, at: index)
                    }
                        
                    index += 1
                        
                    if index == 7 {
                        // the required number of 7 results was achived, further iterations are not needed
                        break
                    }
                }
          
  
                if result.count > 7 {
                    return Array(result.prefix(upTo: 7))
                } else {
                    return result
                }

            } catch {
                
                print("Failed")
            }
        }
        return []
    }
}

extension Date {
    
    func stripTime() -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: self)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: localDate)!

    }
}
