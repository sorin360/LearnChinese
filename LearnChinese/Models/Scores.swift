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
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
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
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Scores")
        // fetchRequest.predicate = NSPredicate(format: "id.uuidString = %@", word.id?.uuidString ?? "")
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
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Scores")
            let sort = NSSortDescriptor(key: "time", ascending: false)
            
            fetchRequest.sortDescriptors = [sort]

            do {
                var result = try managedContext.fetch(fetchRequest) as? [Scores] ?? []
             //   result[count-1]//cea mai mare data
                var count = result.count
                let today = Date()
      
                
               var index = 0
                    
                    while index < result.count{
       
                        if result[index].time != Calendar.current.date(byAdding: .day, value: 0 - index, to: today)?.stripTime(){
                            let newScore = Scores(context: managedContext)
                            newScore.time = Calendar.current.date(byAdding: .day, value: 0 - index, to: today)?.stripTime()
                            newScore.value = 0
                            result.insert(newScore, at: index)
                        }
                        else {
                            break
                        }
                    index += 1
                }
                print(Date())
                count = result.count
 
             /*   while result.count < 7 {
                    
                    let newScore = Scores(context: managedContext)
                    newScore.time = Date().stripTime()
                    newScore.value = 0
                    result += [newScore]
                }*/
                if result.count > 7 {
                    return Array(result.prefix(upTo: 7))
                } else {
                    return result
                }
                /*  for data in result as! [NSManagedObject] {
                 let flashcard = data as? MyFlashcards
                 let name = flashcard?.name ?? ""
                 let words = (flashcard?.words?.allObjects as? [Words]) ?? []
                 for word in words  {
                 colectedData += [word.chinese ?? ""]
                 }
                 /*
                 let word = flashcards?.words?.allObjects as? [Words]
                 let nam = flashcards?.name
                 let name = data.value(forKey: "name") as? String
                 let words = data.value(forKey: "words") as? [NSManagedObject]
                 */
                 colectedData += [name]
                 //  colectedData
                 }
                 */
                do{
                    try managedContext.save()
                }
                catch
                {
                    print(error)
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
      /*  let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        print(components.day)
        let date = Calendar.current.date(from: components)
        print("strip \(date)")
         
         */
     
        let dateFormatter = DateFormatter()
        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter.dateStyle = DateFormatter.Style.short //Set time style
 
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: self)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: localDate)!
       // (bySettingHour: 12, minute: 60, second: 60, of: self)!
       // return date!
    }
    
}
