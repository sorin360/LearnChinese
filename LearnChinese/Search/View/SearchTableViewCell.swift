//
//  SearchTableViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 13/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    var hanziLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        label.textColor = UIColor.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var pinyinLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var englishLabel: UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(hanziLabel)
        self.addSubview(pinyinLabel)
        self.addSubview(englishLabel)
        
        hanziLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        hanziLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0).isActive = true
        
        pinyinLabel.topAnchor.constraint(equalTo: hanziLabel.bottomAnchor).isActive = true
        pinyinLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0).isActive = true
        
        englishLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        englishLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5.0).isActive = true
        englishLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.frame.width / 1.5).isActive = true
        
    }
}
