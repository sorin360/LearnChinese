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
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MyFlashcards")
        let flashcard = word.myLibraries
        // fetchRequest.predicate = NSPredicate(format: "id.uuidString = %@", word.id?.uuidString ?? "")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", (flashcard?.id ?? UUID()) as CVarArg)
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
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MyFlashcards")
        // fetchRequest.predicate = NSPredicate(format: "id.uuidString = %@", word.id?.uuidString ?? "")
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
        
        //here adding 5 data with loop
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
        
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity
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
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MyFlashcards")
        // fetchRequest.predicate = NSPredicate(format: "id.uuidString = %@", word.id?.uuidString ?? "")
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
