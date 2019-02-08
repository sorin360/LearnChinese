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
    
    func getEnglishWord() -> WordPracticeModel{
        let words =  self.words[curentWordIndex]
        let shortTranslations = words.english?.split(separator: ",")
        if shortTranslations != nil {
            return WordPracticeModel(chinese:  String(shortTranslations?[0] ?? " "), pinyin: "")
        } else {
            return WordPracticeModel(chinese: words.english ?? " ", pinyin: "")
        }
       // sentence.priority -= 1
       // Sentences.update(with: sentence)
   
    }
    
    func getChineseWord() -> WordPracticeModel{
   
        let word =  self.words[curentWordIndex]
        let hanzi = word.chinese ?? " "
        let pinyin = word.pinyin ?? " "
       // let chineseWord = hanzi + "/"+pinyin
      //  sentence.priority -= 1
      //  Sentences.update(with: sentence)
        return WordPracticeModel(chinese: hanzi, pinyin: pinyin)
    }
    
    
    func getShuffledChineseWords() -> [WordPracticeModel]{
        
        var shiffledWords:[WordPracticeModel] = []
        if words.count > 3 {
            while shiffledWords.count < 3 {
                let randomNumber = Int.random(in: 0..<words.count)
                if randomNumber != curentWordIndex && !shiffledWords.contains {$0.chinese == words[randomNumber].chinese } {
                    shiffledWords += [WordPracticeModel(chinese: words[randomNumber].chinese ?? "", pinyin: words[randomNumber].pinyin ?? "")]
                }
            }
            shiffledWords += [WordPracticeModel(chinese: words[curentWordIndex].chinese ?? "", pinyin: words[curentWordIndex].pinyin ?? "")]
        } else {
            for index in words.indices {
                shiffledWords += [WordPracticeModel(chinese: words[index].chinese ?? "", pinyin: words[index].pinyin ?? "")]
            }
        }
        curentWordIndex += 1
        shiffledWords.shuffle()
        return shiffledWords
        
    }
   
    
    func getShuffledEnglishWords() -> [WordPracticeModel]{
      
        var shiffledWords:[WordPracticeModel] = []
        if words.count > 3 {
            while shiffledWords.count < 3 {
                let randomNumber = Int.random(in: 0..<words.count)
                if randomNumber != curentWordIndex && !shiffledWords.contains {$0.chinese == words[randomNumber].shortTranslation() } {
                    
                    shiffledWords += [WordPracticeModel(chinese: words[randomNumber].shortTranslation(), pinyin: "")]
                }
            }
            shiffledWords += [WordPracticeModel(chinese: words[curentWordIndex].shortTranslation(), pinyin: "")]
        } else {
            for index in words.indices {
                shiffledWords += [WordPracticeModel(chinese: words[index].shortTranslation(), pinyin: "")]
            }
        }
        curentWordIndex += 1
        shiffledWords.shuffle()
        return shiffledWords
        
    }
 
    func getCorectAnswer() -> String {
        let corectAnswer = words[curentWordIndex - 1].chinese ?? " "
        return corectAnswer
    }
    
    func check(theAnswer answer: String) ->(Bool,String){
        
        var corectAnswer: String = ""
        if answer.containsChineseCharacters {
 
            corectAnswer = self.words[curentWordIndex - 1].chinese ?? " "
        } else {
            corectAnswer = self.words[curentWordIndex - 1].shortTranslation()
        }
       
        
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
