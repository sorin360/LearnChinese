//
//  PracticeDragDropCellCollectionViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 16/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeDragDropCellCollectionViewCell: UICollectionViewCell {
    
  
    var cellTextLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(cellTextLabel)
        
        cellTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        cellTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    }
}
