//
//  FlashcardCollectionViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 10/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class FlashcardCollectionViewCell: UICollectionViewCell {
    
    var hanziLabelText: NSAttributedString?
    var pinyinLabelText: String?
    
    var hanziLabelCollectionCell: UILabel = {
        let hanziLabel = UILabel()
        hanziLabel.font = hanziLabel.font.withSize(26)
        hanziLabel.textAlignment = .center

        hanziLabel.translatesAutoresizingMaskIntoConstraints = false
        return hanziLabel
    }()
    var pinyinLabelCollectionCell: UILabel = {
        let pinyinLabel = UILabel()
        pinyinLabel.font = pinyinLabel.font.withSize(13)
        pinyinLabel.textAlignment = .center

        pinyinLabel.translatesAutoresizingMaskIntoConstraints = false
        return pinyinLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 2.0
        
        stackView.addArrangedSubview(hanziLabelCollectionCell)
        stackView.addArrangedSubview(pinyinLabelCollectionCell)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
   
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: (self.frame.height - 2 - pinyinLabelCollectionCell.font.lineHeight - hanziLabelCollectionCell.font.lineHeight) / 2).isActive = true
        
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: (0 - self.frame.height + 2 + pinyinLabelCollectionCell.font.lineHeight + hanziLabelCollectionCell.font.lineHeight) / 2).isActive = true
        
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        /*
        self.addSubview(hanziLabelCollectionCell)
        self.addSubview(pinyinLabelCollectionCell)
        
        hanziLabelCollectionCell.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35).isActive = true
        hanziLabelCollectionCell.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        

         hanziLabelCollectionCell.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
         hanziLabelCollectionCell.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        
        pinyinLabelCollectionCell.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15).isActive = true
        
        pinyinLabelCollectionCell.topAnchor.constraint(equalTo: self.hanziLabelCollectionCell.bottomAnchor).isActive = true
        
        pinyinLabelCollectionCell.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        pinyinLabelCollectionCell.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        //pinyinLabelCollectionCell.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let hanziLabelText = hanziLabelText {
            hanziLabelCollectionCell.attributedText = hanziLabelText
        }
        if let pinyinLabelText = pinyinLabelText {
            pinyinLabelCollectionCell.text = pinyinLabelText
        }
    }
    
    
}
