//
//  PracticeDragDrop.swift
//  LearnChinese
//
//  Created by Sorin Lica on 04/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import Foundation

class PracticeTranslateSentence {
    
    var sentences:[Sentences] = []
    var curentSentenceIndex = 0
    var practice: Practice?
    
    
    init(myFlashcards:[MyFlashcards], hskFlashcards:[HskFlashcards]){
        sentences = Sentences.getSentences(for: myFlashcards, hsk: hskFlashcards)
    }
    
    func getEnglishSentence() -> [WordPracticeModel]{
        
        let sentence =  self.sentences[curentSentenceIndex]
        var englishSentence: [WordPracticeModel] = []
        var english = sentence.english?.split(separator: " ") ?? []
            for index in english.indices {
                let word = WordPracticeModel(chinese: String(english[index]), pinyin: "" )
                englishSentence += [word]
            }
        sentence.priority -= 1
        Sentences.update(with: sentence)
        return englishSentence
    }
    
    func getChineseSentence() -> [WordPracticeModel]{
        var chineseSentence: [WordPracticeModel] = []
        let sentence =  self.sentences[curentSentenceIndex]
        var hanzi = sentence.chinese?.map{String($0)} ?? []
        var pinyin = sentence.pinyin?.split(separator: " ") ?? []
  
        if hanzi.count == pinyin.count {
            for index in hanzi.indices {
                let word = WordPracticeModel(chinese: hanzi[index], pinyin: String(pinyin[index]) )
                chineseSentence += [word]
            }
        }

        sentence.priority -= 1
        Sentences.update(with: sentence)
        return chineseSentence
    }
    
    
    func getShuffledChineseWords() -> [WordPracticeModel]{
        var shiffledWords:[WordPracticeModel] = []
        var hanzi = self.sentences[curentSentenceIndex].chinese?.map{String($0)} ?? []
        var pinyin = self.sentences[curentSentenceIndex].pinyin?.split(separator: " ") ?? []
        
        if hanzi.count == pinyin.count {
            for index in hanzi.indices {
                 let word = WordPracticeModel(chinese: hanzi[index], pinyin: String(pinyin[index]) )
                shiffledWords += [word]
            }
        }
        if (sentences.count > curentSentenceIndex + 1) {
            
            var hanzi = self.sentences[curentSentenceIndex + 1].chinese?.map{String($0)} ?? []
            var pinyin = self.sentences[curentSentenceIndex + 1].pinyin?.split(separator: " ") ?? []
            if hanzi.count == pinyin.count {
                for index in hanzi.indices {
                    let word = WordPracticeModel(chinese: hanzi[index], pinyin: String(pinyin[index]) )
                   // word.chinese = hanzi[index]
                   // word.pinyin = String(pinyin[index])
                    shiffledWords += [word]
                }
            }
        }
        else {
            if sentences.count > 0 {
                if hanzi.count == pinyin.count {
                    var hanzi = self.sentences[curentSentenceIndex - 1].chinese?.map{String($0)} ?? []
                    var pinyin = self.sentences[curentSentenceIndex - 1].pinyin?.map{String($0)} ?? []
                    for index in hanzi.indices {
                         let word = WordPracticeModel(chinese: hanzi[index], pinyin: String(pinyin[index]) )
                        shiffledWords += [word]
                    }
                }
            }
        }
        curentSentenceIndex += 1
        shiffledWords.shuffle()
        return shiffledWords
        
    }
    
    func getShuffledEnglishWords() -> [WordPracticeModel]{
        //var shiffledWords:[String] = []//
        var shiffledWordsString = self.sentences[curentSentenceIndex].english?.split(separator: " ") ?? []
       /* for index in hanzi.indices {
            shiffledWords += [hanzi[index]+"/"+pinyin[index]]
        }*/
        if (sentences.count > curentSentenceIndex + 1) {
            shiffledWordsString += self.sentences[curentSentenceIndex + 1].english?.split(separator: " ") ?? []
           /* var hanzi = self.sentences[curentSentenceIndex + 1].chinese?.map{String($0)} ?? []
            var pinyin = self.sentences[curentSentenceIndex + 1].pinyin?.split(separator: " ") ?? []
            for index in hanzi.indices {
                shiffledWords += [hanzi[index]+"/"+pinyin[index]]
            }*/
        }
        else {
            if sentences.count > 0 {
                shiffledWordsString += self.sentences[curentSentenceIndex - 1].english?.split(separator: " ") ?? []
            }
        }
        curentSentenceIndex += 1
        shiffledWordsString.shuffle()
        
        var shiffledWords: [WordPracticeModel] = []
        for index in shiffledWordsString.indices {
            let word = WordPracticeModel(chinese: String(shiffledWordsString[index]), pinyin: "" )
          //  word.english = String(shiffledWordsString[index])
            shiffledWords += [word]
        }
        return shiffledWords
        
    }
    
    func getChineseTextOrCorectAnswer() -> String {
        let corectAnswerString = self.sentences[curentSentenceIndex - 1].chinese
        return corectAnswerString ?? " "
       
    }
    
    
    func check(theAnswer answer: [String]) ->(Bool,String){
       
        var corectAnswer:[String] = []
        if answer.joined(separator: " ").containsChineseCharacters {
            var hanzi = self.sentences[curentSentenceIndex - 1].chinese?.map{String($0)} ?? []
           // var pinyin = self.sentences[curentSentenceIndex - 1].pinyin?.split(separator: " ") ?? []
            for index in hanzi.indices {
                corectAnswer += [String(hanzi[index])]
            }
        } else {
            var english = self.sentences[curentSentenceIndex - 1].english?.split(separator: " ") ?? []
            for index in english.indices {
                corectAnswer += [String(english[index])]
            }
        }
       
        let corectAnswerString = corectAnswer.joined(separator: " ")
        
        if answer.elementsEqual(corectAnswer) {
            practice?.score += 100
            return (true,corectAnswerString)
   
        } else {
            practice?.score -= 50
            return (false,corectAnswerString)
       
        }
    }
    
    
    
    func updateScore(with score:Int){
        practice?.score += score
    }
    func getScore() -> String{
        return String(practice?.score ?? 0)
    }
}
