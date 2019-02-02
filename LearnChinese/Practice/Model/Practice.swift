//
//  Practice.swift
//  LearnChinese
//
//  Created by Sorin Lica on 01/02/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import Foundation

class Practice {
    var score: Int = 0 {
        didSet {
            if score < 0 {
                score = 0
            }
        }
    }
    var progressStatus: Float = 0.0
    
    var lifeStatus = 4
}
