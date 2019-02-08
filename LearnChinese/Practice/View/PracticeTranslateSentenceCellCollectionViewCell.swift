//
//  PracticeTranslateSentenceCellCollectionViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 16/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeTranslateSentenceCellCollectionViewCell: UICollectionViewCell {
    
  
    var chineseLabelText: String?
    var pinyinLabelText: String?
    
    
    var chineseLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = UIColor.blue
        
        label.textAlignment = .center
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 2
       
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var pinyinLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        self.addSubview(chineseLabel)
        self.addSubview(pinyinLabel)

        chineseLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        chineseLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
       // chineseLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        chineseLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        pinyinLabel.topAnchor.constraint(equalTo: chineseLabel.bottomAnchor).isActive = true
        pinyinLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pinyinLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
}
