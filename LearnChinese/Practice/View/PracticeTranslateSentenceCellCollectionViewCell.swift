//
//  PracticeTranslateSentenceCellCollectionViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 16/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeTranslateSentenceCellCollectionViewCell: UICollectionViewCell {
    
    var hanziLabel: UILabel = {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(hanziLabel)
        self.addSubview(pinyinLabel)

        hanziLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        hanziLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        hanziLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        pinyinLabel.topAnchor.constraint(equalTo: hanziLabel.bottomAnchor).isActive = true
        pinyinLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pinyinLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
