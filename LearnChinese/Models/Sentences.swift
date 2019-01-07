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
            newSentence.id = UUID.init()
            newSentence.chinese = sentence.hanzi
            newSentence.pinyin = sentence.pinyin
            newSentence.english = sentence.english
            newSentence.priority = 0
            do {
                try context.save()
                UserDefaults.standard.set(true, forKey: "firstUse")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    static func update(with sentence: Sentences){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Sentences")
        // fetchRequest.predicate = NSPredicate(format: "id.uuidString = %@", word.id?.uuidString ?? "")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", sentence.id! as CVarArg)
        do
        {
            
            let test = try managedContext.fetch(fetchRequest)
            if test.count > 0 {
                let objectUpdate = test[0] as! Sentences //
                objectUpdate.priority = sentence.priority
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
    
    static func decreseAllSentencesPriority(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Sentences")
        // fetchRequest.predicate = NSPredicate(format: "id.uuidString = %@", word.id?.uuidString ?? "")
        do
        {
            
            let result = try managedContext.fetch(fetchRequest)
            for sentence in result as! [Sentences] {
                sentence.priority -= 1
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
    
    static func getSentences(for myFlashcardsSelected: [MyFlashcards], and hskFlashcardsSelected: [HskFlashcards]) -> [Sentences] {
    
        var foundSentences:[Sentences] = []
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sentences")
            
            var selectedWords:[String] = [""," ","。","，","? "," ","？","1","2","3","4"]
            
            for index in myFlashcardsSelected.indices {
                let words = myFlashcardsSelected[index].words?.allObjects as! [Words]
                let _ = words.map { selectedWords.append($0.chinese ?? "")}
            }
            for index in hskFlashcardsSelected.indices {
                let words = hskFlashcardsSelected[index].words?.allObjects as! [Words]
                let _ = words.map { selectedWords += ($0.chinese?.map{ String($0)  }) ?? [] }
            }
            let listSet = Set(selectedWords)
           
            let sort = NSSortDescriptor(key: "priority", ascending: true)
            
            fetchRequest.sortDescriptors = [sort]
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                for sentence in (result as? [Sentences] ?? []) {
                    let hanzi = sentence.chinese?.map{ String($0) }
                    let findListSet = Set(hanzi ?? [])
                    print(sentence.english)
                 //   let list = ["我","不","爱","你","了"]
                   // let findList = ["我","爱","了"]
                   // let listSet = Set(list)
                  //  let findListSet = Set(findList)
                    
                    
                    if findListSet.isSubset(of: listSet) {
                        foundSentences += [sentence]
                    }
                    if foundSentences.count == 10 {
                        break
                    }
                    
  
                    
                    
                }

            } catch {
                
                print("Failed")
            }
        }
        return foundSentences
    }
    
}
