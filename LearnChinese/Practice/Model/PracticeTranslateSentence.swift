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
    
    
    init(myLibraries:[MyLibraries], hskLibraries:[HskLibraries]){
        sentences = Sentences.getSentences(for: myLibraries, hsk: hskLibraries)
    }
    
    func getEnglishSentence() -> [WordPracticeModel]{
        
        let sentence =  self.sentences[curentSentenceIndex]
        var englishSentence: [WordPracticeModel] = []
        let english = sentence.english?.split(separator: " ") ?? []
        for index in english.indices {
            let word = WordPracticeModel(wordText: String(english[index]), pinyin: "" )
            englishSentence += [word]
        }
        //update priority of the sentence
        sentence.priority -= 1
        Sentences.updatePriority(of: sentence)
        return englishSentence
    }
    
    func getChineseSentence() -> [WordPracticeModel]{
        
        var chineseSentence: [WordPracticeModel] = []
        let sentence =  self.sentences[curentSentenceIndex]
        
        let hanzi = sentence.chinese?.map{String($0)} ?? []
        let pinyin = sentence.pinyin?.split(separator: " ") ?? []
  
        if hanzi.count == pinyin.count {
            for index in hanzi.indices {
                let word = WordPracticeModel(wordText: hanzi[index], pinyin: String(pinyin[index]) )
                chineseSentence += [word]
            }
        }
        //update priority of the sentence
        sentence.priority -= 1
        Sentences.updatePriority(of: sentence)
        return chineseSentence
    }
    
    
    func getShuffledChineseWords() -> [WordPracticeModel]{
        var shiffledWords:[WordPracticeModel] = []
        let hanzi = self.sentences[curentSentenceIndex].chinese?.map{String($0)} ?? []
        let pinyin = self.sentences[curentSentenceIndex].pinyin?.split(separator: " ") ?? []
        
        if hanzi.count == pinyin.count {
            for index in hanzi.indices {
                 let word = WordPracticeModel(wordText: hanzi[index], pinyin: String(pinyin[index]) )
                shiffledWords += [word]
            }
        }
        // if it's available get words for the next sentence from array
        if (sentences.count > curentSentenceIndex + 1) {
            
            let hanzi = self.sentences[curentSentenceIndex + 1].chinese?.map{String($0)} ?? []
            let pinyin = self.sentences[curentSentenceIndex + 1].pinyin?.split(separator: " ") ?? []
            if hanzi.count == pinyin.count {
                for index in hanzi.indices {
                    let word = WordPracticeModel(wordText: hanzi[index], pinyin: String(pinyin[index]) )
                    shiffledWords += [word]
                }
            }
        }
        else { // else check for the previous sentence from array
            if sentences.count > 0 {
                if hanzi.count == pinyin.count {
                    let hanzi = self.sentences[curentSentenceIndex - 1].chinese?.map{String($0)} ?? []
                    let pinyin = self.sentences[curentSentenceIndex - 1].pinyin?.map{String($0)} ?? []
                    for index in hanzi.indices {
                         let word = WordPracticeModel(wordText: hanzi[index], pinyin: String(pinyin[index]) )
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

        var shiffledWordsString = self.sentences[curentSentenceIndex].english?.split(separator: " ") ?? []
    
        // if it's available get words for the next sentence from array
        if (sentences.count > curentSentenceIndex + 1) {
            shiffledWordsString += self.sentences[curentSentenceIndex + 1].english?.split(separator: " ") ?? []
        }
        else { // else check for the previous sentence from array
            if sentences.count > 0 {
                shiffledWordsString += self.sentences[curentSentenceIndex - 1].english?.split(separator: " ") ?? []
            }
        }
        curentSentenceIndex += 1
        
        shiffledWordsString.shuffle()
        
        var shiffledWords: [WordPracticeModel] = []
        
        // convert [String] to [WordPracticeModel]
        for index in shiffledWordsString.indices {
            let word = WordPracticeModel(wordText: String(shiffledWordsString[index]), pinyin: "" )
            shiffledWords += [word]
        }
        return shiffledWords
        
    }
    
    // used for SpeechSynthesisVoice
    func getCorectAnswerInChinese() -> String {
        let corectAnswerString = self.sentences[curentSentenceIndex - 1].chinese
        return corectAnswerString ?? " "
       
    }
    
    func check(theAnswer answer: [String]) ->(Bool,String){
       
        var corectAnswer:[String] = []
        if answer.joined(separator: " ").containsChineseCharacters {
            // if the answer is in chinese then extract hanzi from the curent sentence
            let hanzi = self.sentences[curentSentenceIndex - 1].chinese?.map{String($0)} ?? []
            for index in hanzi.indices {
                corectAnswer += [String(hanzi[index])]
            }
        } else {
            // if the answer is in english then extract english from the curent sentence
            let english = self.sentences[curentSentenceIndex - 1].english?.split(separator: " ") ?? []
            for index in english.indices {
                corectAnswer += [String(english[index])]
            }
        }
       
        let corectAnswerString = corectAnswer.joined(separator: " ")
        
        // return that answer state (corect/wrong) along with the corect answer
        if answer.elementsEqual(corectAnswer) {
            updateScore(with: 100)
            return (true,corectAnswerString)
   
        } else {
            updateScore(with: -50)
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
