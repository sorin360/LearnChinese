//
//  Constants.swift
//  LearnChinese
//
//  Created by Sorin Lica on 13/02/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import Foundation

enum Constants: String {
    
    case wordsUrl = "https://sorin360.github.io/LearnChineseResources/hskWords1-5.json"
    case sentencesUrl = "https://sorin360.github.io/LearnChineseResources/hskSentences1-2.json"
    case termsOfUseUrl = "https://sorin360.github.io/LearnChineseResources/termsAndConditions.html"
    case helpUrl = "https://sorin360.github.io/LearnChineseResources/home.html"
    //case aboutUrl = "https://sorin360.github.io/LearnChineseResources/home.html"
    
    case feedbackEmail = "lica404@gmail.com"
    
    case firstUseKey = "firstUse"
    
    case alertUpdateDatabaseTitle = "Please wait..."
    case alertUpdateDatabaseMessage = "The database is being updating."
    
    case searchPlaceholder = "Chinese/English"
    
    //sort by
    case pinyinAsc = "Ascending by pinyin"
    case pinyinDes = "Descending by pinyin"
    
    //filters
    case all = "All"
    case known = "Well known"
    case unknown = "Unknown"
    case inLibrary = "In library" 
}
