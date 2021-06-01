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
    
    
    init(myLibraries:[MyLibraries], hskLibraries:[HskLibraries]){
        var words = [Words]()
        for flashcard in myLibraries {
            words += flashcard.words?.allObjects as? [Words] ?? []
        }
        for flashcard in hskLibraries {
            words += flashcard.words?.allObjects as? [Words] ?? []
        }
        words.shuffle()
        // get only the first 5 words from the selected libraries
        if words.count > 5 {
            self.words = Array(words.prefix(5))
        } else {
            self.words = words
        }
    }
    
    func getEnglishWord() -> WordPracticeModel{
        let word =  self.words[curentWordIndex]
        // get only the first description for the word
        let shortTranslations = word.shortTranslation()
   
        return WordPracticeModel(wordText: shortTranslations, pinyin: "")
    }
    
    func getChineseWord() -> WordPracticeModel{
   
        let word =  self.words[curentWordIndex]
        let hanzi = word.chinese ?? " "
        let pinyin = word.pinyin ?? " "
        return WordPracticeModel(wordText: hanzi, pinyin: pinyin)
    }
    
    
    func getShuffledChineseWords() -> [WordPracticeModel]{
        
        var shiffledWords:[WordPracticeModel] = []
        if words.count > 3 {
            // if the array contains more than 3 words then chose 3 random words
            while shiffledWords.count < 3 {
                let randomNumber = Int.random(in: 0..<words.count)
                if randomNumber != curentWordIndex && !shiffledWords.contains(where: {$0.wordText == words[randomNumber].chinese }) {
                    shiffledWords += [WordPracticeModel(wordText: words[randomNumber].chinese ?? "", pinyin: words[randomNumber].pinyin ?? "")]
                }
            }
            // add the corect answer in list
            shiffledWords += [WordPracticeModel(wordText: words[curentWordIndex].chinese ?? "", pinyin: words[curentWordIndex].pinyin ?? "")]
        } else { // all the words will be added to the shiffledWords array (the corect answer is among them)
            for index in words.indices {
                shiffledWords += [WordPracticeModel(wordText: words[index].chinese ?? "", pinyin: words[index].pinyin ?? "")]
            }
        }
        curentWordIndex += 1
        shiffledWords.shuffle()
        return shiffledWords
    }
    
    func getShuffledEnglishWords() -> [WordPracticeModel]{
      
        var shiffledWords:[WordPracticeModel] = []
        if words.count > 3 {
            // if the array contains more than 3 words then chose 3 random words
            while shiffledWords.count < 3 {
                let randomNumber = Int.random(in: 0..<words.count)
                if randomNumber != curentWordIndex && !shiffledWords.contains(where: {$0.wordText == words[randomNumber].shortTranslation() }) {
                    
                    shiffledWords += [WordPracticeModel(wordText: words[randomNumber].shortTranslation(), pinyin: "")]
                }
            }
            // add the corect answer in list
            shiffledWords += [WordPracticeModel(wordText: words[curentWordIndex].shortTranslation(), pinyin: "")]
        } else { // all the words will be added to the shiffledWords array (the corect answer is among them)
            for index in words.indices {
                shiffledWords += [WordPracticeModel(wordText: words[index].shortTranslation(), pinyin: "")]
            }
        }
        curentWordIndex += 1
        shiffledWords.shuffle()
        return shiffledWords
        
    }
 
    // used for SpeechSynthesisVoice
    func getCorectAnswerInChinese() -> String {
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
