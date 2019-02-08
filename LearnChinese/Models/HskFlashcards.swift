//
//  HskFlashcards.swift
//  LearnChinese
//
//  Created by Sorin Lica on 06/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import CoreData

class HskFlashcards: NSManagedObject {

    static func addFlashcardBunch(in context: NSManagedObjectContext, with dataArray: [CodableHskFlashcardsModel]){
        var flag = 0
        for data in dataArray {
            let flashcards = HskFlashcards(context: context)
            //hack
            
            if data.level == "HSK 1" {
               
                if flag == 1 {
                    flashcards.level = "HSK 3"
                }
                else {
                     flag = 1
                     flashcards.level = data.level ?? "HSK 0"
                }
            }
            else {
                 flashcards.level = data.level ?? "HSK 0"
            }
           
            
            
           // flashcards.level = data.level ?? "HSK 0"
            for wordsIndex in data.words.indices {
                let word = Words(context: context)
                word.chinese = data.words[wordsIndex].hanzi
                word.pinyin = data.words[wordsIndex].pinyin
                word.id = UUID.init()
                word.english = ""
                word.veryKnown = false
                for translationIndex in data.words[wordsIndex].translations.indices {
                    word.english = word.english! + data.words[wordsIndex].translations[translationIndex] + ", "
                }
                flashcards.addToWords(word)
            }
            
            do {
                try context.save()
                UserDefaults.standard.set(true, forKey: "firstUse")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
 
    
    
    static func retrieveData() -> [HskFlashcards] {
          //As we know that container is set up in the AppDelegates so we need to refer that container.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HskFlashcards")
            
            //        fetchRequest.fetchLimit = 1
            //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
            //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
            //
            do {
                let result = try managedContext.fetch(fetchRequest)
                return result as? [HskFlashcards] ?? []
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
}



