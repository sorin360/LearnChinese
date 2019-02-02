//
//  PracticeTranslateSentenceCellCollectionViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 16/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeTranslateSentenceCellCollectionViewCell: UICollectionViewCell {
    
  
    var cellTextLabel: UILabel = {
        var label = UILabel()
      //  label.backgroundColor = UIColor.yellow
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(cellTextLabel)
        //self.backgroundColor = UIColor.green
        cellTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        cellTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
