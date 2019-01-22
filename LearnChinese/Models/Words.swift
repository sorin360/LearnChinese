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
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Words")
        // fetchRequest.predicate = NSPredicate(format: "id.uuidString = %@", word.id?.uuidString ?? "")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", word.id! as CVarArg)
        do
        {
            
            let test = try managedContext.fetch(fetchRequest)
            if test.count > 0 {
                let objectUpdate = test[0] as! Words //
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
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
            fetchRequest.predicate = NSPredicate(format: "%K == YES", "veryKnown")
            
            //        fetchRequest.fetchLimit = 1
            //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
            //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
            //
            do {
                let result = try managedContext.fetch(fetchRequest)
                
                return result as? [Words] ?? []
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
            } catch {
                
                print("Failed")
            }
        }
        return []
    }
    
    static func search(with filter: String) -> [Words] {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
            if filter.containsChineseCharacters {
                fetchRequest.predicate = NSPredicate(format: "chinese CONTAINS %@", filter)
            }
            else {
                fetchRequest.predicate = NSPredicate(format: "ANY english CONTAINS[c] %@", filter)
            }
            
            //        fetchRequest.fetchLimit = 1
            //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
            //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
            //
            do {
                let result = try managedContext.fetch(fetchRequest)
                
                return result as? [Words] ?? []
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
                    print("random number" + String(randomNumber))
                    print("random nudmber" + String( result.count - 1))
               
                    return result[randomNumber]
                    
                }
            } catch {
                print("Failed")
            }
        }
        return nil
    }
    
    static func getDailyRandomNumber(upto maxValue: Int) -> Int{
    
        let storedSeed = UserDefaults.standard.integer(forKey: "RandomNumberSeed")
 
        let curentDate = Date().description.split(separator: " ")[0]
        let splittedDate = curentDate.split(separator: "-")
        let todaySeed = Int(splittedDate[0]+splittedDate[1]+splittedDate[2])
        print("randomDate " + String(todaySeed!))
        print("randomStored" + String(storedSeed))
        print(storedSeed != todaySeed)
        if storedSeed != todaySeed {
            // a new day
            // decrese sentences priorities
            Sentences.decreseAllSentencesPriority()
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
