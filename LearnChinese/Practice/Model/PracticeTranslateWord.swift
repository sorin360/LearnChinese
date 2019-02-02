//
//  PracticeTranslateWord.swift
//  LearnChinese
//
//  Created by Sorin Lica on 31/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import Foundation

class PracticeTranslateWord {
    
    var words:[Words] = []
    var curentWordIndex = 0
    var practice: Practice?
    
    
    init(myFlashcards:[MyFlashcards], hskFlashcards:[HskFlashcards]){
        var words = [Words]()
        for flashcard in myFlashcards {
            words += flashcard.words?.allObjects as? [Words] ?? []
        }
        for flashcard in hskFlashcards {
            words += flashcard.words?.allObjects as? [Words] ?? []
        }
        words.shuffle()
        if words.count > 5 {
            self.words = Array(words.prefix(5))
        } else {
            self.words = words
        }
        // sort words by priority
        
      
    }
    
    func getEnglishWord() -> String{
        let words =  self.words[curentWordIndex]
        let shortTranslations = words.english?.split(separator: ",")
        if shortTranslations != nil {
            return String(shortTranslations?[0] ?? " ")
        } else {
            return words.english ?? " "
        }
       // sentence.priority -= 1
       // Sentences.update(with: sentence)
   
    }
    
    func getChineseWord() -> String{
   
        let word =  self.words[curentWordIndex]
        let hanzi = word.chinese ?? " "
        let pinyin = word.pinyin ?? " "
        let chineseWord = hanzi + "/"+pinyin
      //  sentence.priority -= 1
      //  Sentences.update(with: sentence)
        return chineseWord
    }
    
    
    func getShuffledChineseWords() -> [String]{
        
        var shiffledWords:[String] = []
        if words.count > 3 {
            while shiffledWords.count < 3 {
                let randomNumber = Int.random(in: 0..<words.count)
                if randomNumber != curentWordIndex && !shiffledWords.contains((words[randomNumber].chinese ?? " ") + "/" + (words[randomNumber].pinyin ?? " ")){
                    shiffledWords += [(words[randomNumber].chinese ?? " ") + "/" + (words[randomNumber].pinyin ?? " ")]
                }
            }
            shiffledWords += [(words[curentWordIndex].chinese ?? " ") + "/" + (words[curentWordIndex].pinyin ?? " ")]
        } else {
            for index in words.indices {
                shiffledWords += [(words[index].chinese ?? " ") + "/" + (words[index].pinyin ?? " ")]
            }
        }
        curentWordIndex += 1
        shiffledWords.shuffle()
        return shiffledWords
        
    }
   
    
    func getShuffledEnglishWords() -> [String]{
      
        var shiffledWords:[String] = []
        if words.count > 3 {
            while shiffledWords.count < 3 {
                let randomNumber = Int.random(in: 0..<words.count)
                if randomNumber != curentWordIndex && !shiffledWords.contains(words[randomNumber].shortTranslation()){
                    
                    shiffledWords += [words[randomNumber].shortTranslation()]
                }
            }
            shiffledWords += [words[curentWordIndex].shortTranslation()]
        } else {
            for index in words.indices {
                shiffledWords += [words[index].shortTranslation()]
            }
        }
        curentWordIndex += 1
        shiffledWords.shuffle()
        return shiffledWords
        
    }
    
    func check(theAnswer answer: String) ->(Bool,String){
        
        var corectAnswer: String = ""
        if answer.containsChineseCharacters {
            let hanzi = self.words[curentWordIndex - 1].chinese ?? " "
            let pinyin = self.words[curentWordIndex - 1].pinyin ?? " "
            
            corectAnswer = hanzi + "/" + pinyin
        } else {
            corectAnswer = self.words[curentWordIndex - 1].shortTranslation()
        }
        print(corectAnswer)
        
        if (answer == corectAnswer) {
            practice?.score += 100
            return (true,corectAnswer)
            
        } else {
            practice?.score -= 50
            return (false,corectAnswer)
            
        }
    }
    
    
    
    func updateScore(with score:Int){
        practice?.score += score
    }
    func getScore() -> String{
        return String(practice?.score ?? 0)
    }
}
