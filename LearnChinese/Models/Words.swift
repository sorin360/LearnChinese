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
                fetchRequest.predicate = NSPredicate(format: "english CONTAINS %@", filter)
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
            
                    let randomNumber = getDailyRandomNumber(up: result.count - 1)
                   // print(randomNumber)
                    return result[randomNumber]
                    
                }
            } catch {
                print("Failed")
            }
        }
        return nil
    }
    
    static func getDailyRandomNumber(up to: Int) -> Int{
    
        let randomNumberSeed = UserDefaults.standard.double(forKey: "RandomNumberSeed")
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let curentDate = dateFormatter.date(from: String(Date().description.split(separator: " ")[0]))
        
        

        if randomNumberSeed != curentDate?.timeIntervalSince1970 {
            let notSoRandomSource1 = GKMersenneTwisterRandomSource(seed: UInt64((curentDate?.timeIntervalSince1970)!))
            let numberForToday = GKRandomDistribution(randomSource: notSoRandomSource1,
                                                      lowestValue: 0,
                                                      highestValue: to)
            UserDefaults.standard.set(curentDate?.timeIntervalSince1970, forKey: "RandomNumberSeed")
            UserDefaults.standard.set(numberForToday.nextInt(), forKey: "RandomNumber")
            return numberForToday.nextInt()
         }
         return UserDefaults.standard.integer(forKey: "RandomNumber")
    }
}
extension String {
    var containsChineseCharacters: Bool {
        return self.range(of: "\\p{Han}", options: .regularExpression) != nil
    }
}
