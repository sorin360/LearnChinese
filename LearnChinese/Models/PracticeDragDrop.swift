//
//  PracticeDragDrop.swift
//  LearnChinese
//
//  Created by Sorin Lica on 04/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import Foundation

class PracticeDragDrop {
    
    var sentences:[Sentences] = []
    var curentSentenceIndex = 0
    var score = 0

    
    init(myFlashcards:[MyFlashcards], hskFlashcards:[HskFlashcards]){
        sentences = Sentences.getSentences(for: myFlashcards, and: hskFlashcards)
    }
    
    func getSentence() -> Sentences{
        return self.sentences[curentSentenceIndex]
        
    }
    
    func getShuffledWords() -> [String]{
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
    
    func check(theAnswer answer: [String]) ->(Bool,String){
       
        var corectAnswer:[String] = []
        var hanzi = self.sentences[curentSentenceIndex - 1].chinese?.map{String($0)} ?? []
        var pinyin = self.sentences[curentSentenceIndex - 1].pinyin?.split(separator: " ") ?? []
        for index in hanzi.indices {
            corectAnswer += [hanzi[index]+"/"+pinyin[index]]
        }
        print(corectAnswer)
        let corectAnswerString = corectAnswer.joined(separator: " ")
        
        if answer.elementsEqual(corectAnswer) {
            score += 100
            return (true,corectAnswerString)
   
        } else {
            score -= 50
            return (false,corectAnswerString)
       
        }
    }
    
    func updateScore(with score:Int){
        self.score += score
    }
    func getScore() -> String{
        return String(score)
    }
}
