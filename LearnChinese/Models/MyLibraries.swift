//
//  MyFlashcards.swift
//  LearnChinese
//
//  Created by Sorin Lica on 05/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import CoreData

class MyLibraries: NSManagedObject {
    
    static func remove(word: Words){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MyFlashcards")
        let library = word.myLibraries

        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", (library?.id ?? UUID()) as CVarArg)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            if test.count > 0 {
                let objectUpdate = test[0] as! MyLibraries //
                objectUpdate.removeFromWords(word)
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
    static func update(myFlashcards: MyLibraries){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MyLibraries")
        
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", myFlashcards.id! as CVarArg)
        do
        {
            
            let test = try managedContext.fetch(fetchRequest)
            if test.count > 0 {
                let objectUpdate = test[0] as! MyLibraries //
                objectUpdate.words = myFlashcards.words
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
    
   
    
    static func addLibrary(with name: String) -> MyLibraries{
       
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let context = appDelegate!.persistentContainer.viewContext
        
        let flashcards = MyLibraries(context: context)
        flashcards.name = name
        flashcards.id = UUID.init()
        
        do {
            try context.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return flashcards
    }
    
  
    static func retrieveData() -> [MyLibraries] {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
       
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyFlashcards")
            do {
                let result = try managedContext.fetch(fetchRequest)
                return result as? [MyLibraries] ?? []
            
            } catch {
                print("Failed")
            }
        }
        return []
    }
    static func delete(myFlashcards: MyLibraries){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MyFlashcards")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", myFlashcards.id! as CVarArg)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            if test.count > 0 {
                let objectUpdate = test[0] as! MyLibraries //
                 managedContext.delete(objectUpdate)
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
}
