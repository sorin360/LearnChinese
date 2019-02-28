//
//  HskFlashcards.swift
//  LearnChinese
//
//  Created by Sorin Lica on 06/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import CoreData

class HskLibraries: NSManagedObject {

    static func add(data dataArray: [CodableHskFlashcardsModel], in context: NSManagedObjectContext){
      
        for data in dataArray {
            let flashcards = HskLibraries(context: context)
    
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
    
 
    
    
    static func getHskLibraries() -> [HskLibraries] {
  
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HskLibraries")
   
            do {
                let result = try managedContext.fetch(fetchRequest)
                return result as? [HskLibraries] ?? []
               
            } catch {
                
                print("Failed")
            }
        }
        return []
    }
}



