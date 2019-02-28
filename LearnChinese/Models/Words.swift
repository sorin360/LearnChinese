//
//  Words.swift
//  LearnChinese
//
//  Created by Sorin Lica on 04/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import CoreData
import GameplayKit

class Words: NSManagedObject {
    
    static func update(with word: Words){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Words")
   
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", word.id! as CVarArg)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            if test.count > 0 {
                let objectUpdate = test[0] as! Words
                objectUpdate.veryKnown = word.veryKnown
                do{
                    try managedContext.save()
                }
                catch
                {
                    print(error)
                }
            }
        }
        catch
        {
            print(error)
        }
        
    }
    
    static func getKnownWords() -> [Words] {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
   
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
            fetchRequest.predicate = NSPredicate(format: "%K == YES", "veryKnown")

            do {
                let result = try managedContext.fetch(fetchRequest)
                
                return result as? [Words] ?? []

            } catch {
                
                print("Failed")
            }
        }
        return []
    }
    
    static func search(with filter: String) -> [Words] {
        

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            let managedContext = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
            if filter.containsChineseCharacters {
                fetchRequest.predicate = NSPredicate(format: "chinese CONTAINS %@", filter)
            }
            else {
                fetchRequest.predicate = NSPredicate(format: "ANY english CONTAINS[c] %@", filter)
            }
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                return result as? [Words] ?? []
            } catch {
                
                print("Failed")
            }
        }
        return []
    }
    static func getTheWordOfTheDay() -> Words? {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
            
            do {
                let result = (try managedContext.fetch(fetchRequest)) as? [Words] ?? []
                if result.count > 0 {
            
                    let randomNumber = getDailyRandomNumber(upto: result.count - 1)
            
               
                    return result[randomNumber]
                    
                }
            } catch {
                print("Failed")
            }
        }
        return nil
    }
    
    static func getDailyRandomNumber(upto maxValue: Int) -> Int{
    
        let storedSeed = UserDefaults.standard.integer(forKey: "RandomNumberSeed") // curent day
 
        let curentDate = Date().description.split(separator: " ")[0]
        let splittedDate = curentDate.split(separator: "-")
        let todaySeed = Int(splittedDate[0]+splittedDate[1]+splittedDate[2])

        print(storedSeed != todaySeed)
        if storedSeed != todaySeed {
            // a new day
            // decrese sentences priorities
            Sentences.increseAllSentencesPriority()
            let notSoRandomSource1 = GKMersenneTwisterRandomSource(seed: UInt64(todaySeed ?? 0))
            let numberForToday = GKRandomDistribution(randomSource: notSoRandomSource1,
                                                      lowestValue: 0,
                                                      highestValue: maxValue)
            UserDefaults.standard.set(todaySeed, forKey: "RandomNumberSeed")
            UserDefaults.standard.set(numberForToday.nextInt(), forKey: "RandomNumber")
         }
         return UserDefaults.standard.integer(forKey: "RandomNumber")
    }
}

extension String {
    var containsChineseCharacters: Bool {
        return self.range(of: "\\p{Han}", options: .regularExpression) != nil
    }
}

extension Words {
    func shortTranslation() -> String {
        let shortTranslations = self.english?.split(separator: ",")
        if shortTranslations != nil {
            return String(shortTranslations?[0] ?? " ")
        } else {
            return self.english ?? " "
        }
    }
}
