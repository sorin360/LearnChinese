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
    
    func getEnglishSentence() -> String{
        let sentence =  self.sentences[curentSentenceIndex]
        sentence.priority -= 1
        Sentences.update(with: sentence)
        return sentence.english ?? " "
    }
    
    func getChineseSentence() -> String{
        var chineseSentence:String = ""
        let sentence =  self.sentences[curentSentenceIndex]
        var hanzi = sentence.chinese?.map{String($0)} ?? []
        var pinyin = sentence.pinyin?.split(separator: " ") ?? []
        if hanzi.count == pinyin.count {
            for index in hanzi.indices {
               chineseSentence += hanzi[index]+"/"+pinyin[index]+" "
            }
        }
        
        sentence.priority -= 1
        Sentences.update(with: sentence)
        return chineseSentence
    }
    
    
    func getShuffledChineseWords() -> [String]{
        var shiffledWords:[String] = []
        var hanzi = self.sentences[curentSentenceIndex].chinese?.map{String($0)} ?? []
        var pinyin = self.sentences[curentSentenceIndex].pinyin?.split(separator: " ") ?? []
        for index in hanzi.indices {
            shiffledWords += [hanzi[index]+"/"+pinyin[index]]
        }
        if (sentences.count > curentSentenceIndex + 1) {
            
            var hanzi = self.sentences[curentSentenceIndex + 1].chinese?.map{String($0)} ?? []
            var pinyin = self.sentences[curentSentenceIndex + 1].pinyin?.split(separator: " ") ?? []
            for index in hanzi.indices {
                shiffledWords += [hanzi[index]+"/"+pinyin[index]]
            }
        }
        else {
            if sentences.count > 0 {
                var hanzi = self.sentences[curentSentenceIndex - 1].chinese?.map{String($0)} ?? []
                var pinyin = self.sentences[curentSentenceIndex - 1].pinyin?.map{String($0)} ?? []
                for index in hanzi.indices {
                    shiffledWords += [hanzi[index]+"/"+pinyin[index]]
                }
            }
        }
        curentSentenceIndex += 1
        shiffledWords.shuffle()
        return shiffledWords
        
    }
    
    func getShuffledEnglishWords() -> [String]{
        //var shiffledWords:[String] = []//
        var shiffledWords = self.sentences[curentSentenceIndex].english?.split(separator: " ") ?? []
       /* for index in hanzi.indices {
            shiffledWords += [hanzi[index]+"/"+pinyin[index]]
        }*/
        if (sentences.count > curentSentenceIndex + 1) {
            shiffledWords += self.sentences[curentSentenceIndex + 1].english?.split(separator: " ") ?? []
           /* var hanzi = self.sentences[curentSentenceIndex + 1].chinese?.map{String($0)} ?? []
            var pinyin = self.sentences[curentSentenceIndex + 1].pinyin?.split(separator: " ") ?? []
            for index in hanzi.indices {
                shiffledWords += [hanzi[index]+"/"+pinyin[index]]
            }*/
        }
        else {
            if sentences.count > 0 {
                shiffledWords += self.sentences[curentSentenceIndex - 1].english?.split(separator: " ") ?? []
            }
        }
        curentSentenceIndex += 1
        shiffledWords.shuffle()
        var shiffledWordsString: [String] = []
        for index in shiffledWords.indices {
            shiffledWordsString += [String(shiffledWords[index])]
        }
        return shiffledWordsString
        
    }
    
    func check(theAnswer answer: [String]) ->(Bool,String){
       
        var corectAnswer:[String] = []
        if answer.joined(separator: " ").containsChineseCharacters {
            var hanzi = self.sentences[curentSentenceIndex - 1].chinese?.map{String($0)} ?? []
            var pinyin = self.sentences[curentSentenceIndex - 1].pinyin?.split(separator: " ") ?? []
            for index in hanzi.indices {
                corectAnswer += [hanzi[index]+"/"+pinyin[index]]
            }
        } else {
            var english = self.sentences[curentSentenceIndex - 1].english?.split(separator: " ") ?? []
            for index in english.indices {
                corectAnswer += [String(english[index])]
            }
        }
        print(corectAnswer)
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
