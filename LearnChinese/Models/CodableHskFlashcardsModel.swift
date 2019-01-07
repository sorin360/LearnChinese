//
//  CodableHskFlashcardsModel.swift
//  LearnChinese
//
//  Created by Sorin Lica on 06/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import Foundation
import UIKit

struct CodableHskFlashcardsModel: Codable {
    var level: String?
    var words: [Word]
    
    struct Word: Codable{
        var hanzi: String?
        var pinyin: String?
        var translations: [String]
    }
}
