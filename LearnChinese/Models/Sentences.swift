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

    static func add(data arrayData: [CodableSentencesModel], to context: NSManagedObjectContext){
        
      
        var exception = false
        
        for sentence in arrayData {
            let hanzi = sentence.hanzi.map{String($0)}
            let pinyin = sentence.pinyin?.split(separator: " ") 
            if hanzi?.count == pinyin?.count {
                let newSentence = Sentences(context: context)
                newSentence.id = UUID.init()
                newSentence.chinese = sentence.hanzi
                newSentence.pinyin = sentence.pinyin
                newSentence.english = sentence.english
                newSentence.priority = 0
            }
            do {
                try context.save()
                
            } catch _ as NSError {
                exception = true
            }
        }
        if !exception {
            UserDefaults.standard.set(true, forKey: "firstUse")
        }
    }
    
    static func updatePriority(of sentence: Sentences){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Sentences")
     
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", sentence.id! as CVarArg)
        do
        {
            let foundData = try managedContext.fetch(fetchRequest)
            if foundData.count > 0 {
                let objectUpdate = foundData[0] as! Sentences
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
    
    static func increseAllSentencesPriority(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Sentences")
 
        do
        {
            let result = try managedContext.fetch(fetchRequest)
            for sentence in result as! [Sentences] {
                sentence.priority += 1
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
    
   
   static func getSentences(for myLibrariesSelected: [MyLibraries], hsk hskFlashcardsSelected: [HskLibraries]) -> [Sentences] {
    
        var foundSentences:[Sentences] = []

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            
      
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sentences")
            
            var selectedWords:[String] = [""," ","。","，","? "," ","？","1","2","3","4","5","6","7","8","9","0"]
            
            for index in myLibrariesSelected.indices {
                let words = myLibrariesSelected[index].words?.allObjects as! [Words]
                let _ = words.map { selectedWords.append($0.chinese ?? "")}
            }
            for index in hskFlashcardsSelected.indices {
                let words = hskFlashcardsSelected[index].words?.allObjects as! [Words]
                let _ = words.map { selectedWords += ($0.chinese?.map{ String($0)  }) ?? [] }
            }
            
            let wellKnownWords = Words.getKnownWords()
          
            let _ = wellKnownWords.map { selectedWords += ($0.chinese?.map{ String($0)  }) ?? [] }
            
            let listSet = Set(selectedWords)
           
            let sort = NSSortDescriptor(key: "priority", ascending: false)
            
            fetchRequest.sortDescriptors = [sort]
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                for sentence in (result as? [Sentences] ?? []) {
                    let hanzi = sentence.chinese?.map{ String($0) }
                    let findListSet = Set(hanzi ?? [])
                    if findListSet.isSubset(of: listSet) {
                        foundSentences += [sentence]
                    }
                    if foundSentences.count == 5 {
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
