//
//  FlashcardDetailsCollectionViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 10/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class FlashcardDetailsCollectionViewCell: UICollectionViewCell {
    
    var word: Words?
    
    @IBOutlet weak var hanziLabelCollectionCell: UILabel?
    @IBOutlet weak var pinyinLabelCollectionCell: UILabel!
    @IBOutlet weak var translationLabelColectionCell: UILabel!
    @IBOutlet weak var IknowitButtonCollectionCell: UIButton! {
        didSet {
            IknowitButtonCollectionCell.layer.cornerRadius = 10.0
            IknowitButtonCollectionCell.layer.borderWidth = 1.0
            IknowitButtonCollectionCell.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    
    @IBAction func IknowitButton(_ sender: UIButton) {
        if let newWord = word {
            if newWord.veryKnown {
                newWord.veryKnown = false
                IknowitButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "I know this word very well!"), for: .normal)
            }
            else {
                newWord.veryKnown = true
                IknowitButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "I do not remember this word!"), for: .normal)
            }
            Words.update(with: newWord)
        }
       
    }
    
    
}
