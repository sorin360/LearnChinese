//
//  Sentences.swift
//  LearnChinese
//
//  Created by Sorin Lica on 05/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import CoreData

class Sentences: NSManagedObject {

    static func addSentences(in context: NSManagedObjectContext, with data: [CodableSentencesModel]){
        
        for sentence in data {
            let newSentence = Sentences(context: context)
            newSentence.chinese = sentence.hanzi
            newSentence.pinyin = sentence.pinyin
            newSentence.english = sentence.translation
            
            do {
                try context.save()
                UserDefaults.standard.set(true, forKey: "firstUse")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    static func retrieveData() -> Int {
        

        //As we know that container is set up in the AppDelegates so we need to refer that container.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sentences")

            do {
                let result = try managedContext.fetch(fetchRequest)
                return (result as? [Sentences] ?? []).count

            } catch {
                
                print("Failed")
            }
        }
        return 0
    }
    
}
