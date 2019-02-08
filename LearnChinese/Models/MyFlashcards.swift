//
//  MyFlashcards.swift
//  LearnChinese
//
//  Created by Sorin Lica on 05/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import CoreData

class MyFlashcards: NSManagedObject {
    
    
    static func remove(word: Words){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MyFlashcards")
        let flashcard = word.flashcard
        // fetchRequest.predicate = NSPredicate(format: "id.uuidString = %@", word.id?.uuidString ?? "")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", (flashcard?.id ?? UUID()) as CVarArg)
        do
        {
            
            let test = try managedContext.fetch(fetchRequest)
            if test.count > 0 {
                let objectUpdate = test[0] as! MyFlashcards //
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
    static func update(myFlashcards: MyFlashcards){
        
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
                let objectUpdate = test[0] as! MyFlashcards //
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
    
   
    
    static func addFlashcardBunch(in context: NSManagedObjectContext, with name: String) -> MyFlashcards{
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        /*   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
         
         //We need to create a context from this container
         let managedContext = appDelegate.persistentContainer.viewContext
         
         //Now let’s create an entity and new user records.
         let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!*/
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        let flashcards = MyFlashcards(context: context)
        flashcards.name = name
        flashcards.id = UUID.init()
        
        
        do {
            try context.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return flashcards
    }
    
  
    static func retrieveData() -> [MyFlashcards] {
        
       // var colectedData:[String] = []
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
        
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyFlashcards")
            
            //        fetchRequest.fetchLimit = 1
            //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
            //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
            //
            do {
                let result = try managedContext.fetch(fetchRequest)
                return result as? [MyFlashcards] ?? []
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
    static func delete(myFlashcards: MyFlashcards){
        
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
                let objectUpdate = test[0] as! MyFlashcards //
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
